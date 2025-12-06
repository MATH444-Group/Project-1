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
  




  clean_data <- data[, variablesToKeep, drop = FALSE]
  message(paste("Variables removed:", ncol(data) - ncol(clean_data)), "\n")
  
  return(clean_data)

}