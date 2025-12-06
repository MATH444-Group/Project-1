dropUncorrelatedPredictors <- function(data, responseVariable = "Y", threshold = 0.3) {
  
  # Safety Checks
  if (nrow(data) == 0) {
    message("The data frame is empty.")
    return(NULL)
  }
  
  if (!responseVariable %in% names(data)) {
    stop(paste("Response variable", responseVariable, "not found in data."))
  }
  




  message(paste("Processing", ncol(data), "variables..."))
  
  # Initialize lists to track what we want to keep
  variablesToKeep <- c(responseVariable)
  
  # Isolated response vector
  y <- data[[responseVariable]]
  




  for (columnName in names(data)) {

    if (columnName == responseVariable) next

    x <- data[[columnName]]


    
    # --- A. Handle Categorical Variables (Factors/Characters) ---
    if (is.factor(x) || is.character(x)) {
      
      try({

        f <- as.formula(paste(responseVariable, "~", columnName))
        test <- summary(aov(f, data = data))
        p_val <- test[[1]][["Pr(>F)"]][1]
        
        if (!is.na(p_val) && p_val < 0.05) {
          variablesToKeep <- c(variablesToKeep, columnName)
        }

      }, silent = TRUE)
      
    } 


    
    # --- B. Handle Numeric Variables (Linear AND Quadratic) ---
    else if (is.numeric(x)) {
      
      # Check Linear Correlation
      r_linear <- cor(x, y, use = "complete.obs")
      
      # Check Quadratic Relationship (Non-linear)
      quad_model <- lm(y ~ poly(x, 2, raw = TRUE))
      r_quad <- sqrt(summary(quad_model)$r.squared)
      
      
      
      if (abs(r_linear) > threshold) {
        variablesToKeep <- c(variablesToKeep, columnName)
      } else if (r_quad > threshold) {
        variablesToKeep <- c(variablesToKeep, columnName)
      }

    }

  }
  




  cleanData <- data[, variablesToKeep, drop = FALSE]
  message(paste("Variables removed:", ncol(data) - ncol(cleanData)), "\n")
  
  return(cleanData)

}





dropHighCollinearPredictors <- function(data, responseVariable = "Y", threshold = 0.8) {

  # Safety Checks
  if (nrow(data) == 0) {
    message("The data frame is empty.")
    return(NULL)
  }
  
  if (!responseVariable %in% names(data)) {
    stop(paste("Response variable", responseVariable, "not found in data."))
  }





  dataToCheck <- data[ , !(names(data) %in% responseVariable)]
  numericColumns <- names(dataToCheck)[sapply(dataToCheck, is.numeric)]
  
  if (length(numericColumns) < 2) {
    message("Not enough numeric variables to check for multicollinearity.\n")
    return(data)
  }
  message(paste("Checking", length(numericColumns), "numeric variables for multicollinearity..."))
  


  correlationMatrix <- cor(dataToCheck[, numericColumns], use = "pairwise.complete.obs")
  
  # Set the diagonal to 0 because every variable correlates 1.0 with itself
  diag(correlationMatrix) <- 0
  
  # Check for strong negative correlation as well
  correlationMatrix <- abs(correlationMatrix)
  
  # Check the upper triangle only because the matrix is symmetrical
  matrixUpperTriangle <- upper.tri(correlationMatrix)
  
  # Find pairs above threshold
  highCorrelationIndices <- which(correlationMatrix > threshold & matrixUpperTriangle, arr.ind = TRUE)
  


  variablesToDrop <- c()
  if (nrow(highCorrelationIndices) > 0) {
    for (i in 1:nrow(highCorrelationIndices)) {

      rowIndex <- highCorrelationIndices[i, "row"]
      columnIndex <- highCorrelationIndices[i, "col"]
      
      var1 <- rownames(correlationMatrix)[rowIndex]
      var2 <- colnames(correlationMatrix)[columnIndex]
      
      # Heuristic: Drop the variable that has the highest MEAN correlation 
      # with *all other* variables (it's the most "redundant" one).
      meanCorrelation1 <- mean(correlationMatrix[rowIndex, ])
      meanCorrelation2 <- mean(correlationMatrix[columnIndex, ])
      
      if (meanCorrelation1 > meanCorrelation2) {
        variablesToDrop <- c(variablesToDrop, var1)
      } else {
        variablesToDrop <- c(variablesToDrop, var2)
      }
    }
  }
  
  # Unique list of drops (a variable might be flagged multiple times)
  variablesToDrop <- unique(variablesToDrop)
  




  if (length(variablesToDrop) > 0) {

    message(paste("Dropping", length(variablesToDrop), "collinear variables:", paste(variablesToDrop, collapse = ", ")), "\n")
    cleanData <- data[, !names(data) %in% variablesToDrop]
    return(cleanData)

  } else {

    message("No multicollinearity found above threshold.\n")
    return(data)

  }

}