runPCA <- function(data, responseVariable, lambdas = NULL, threshold = 0.95, summarize = FALSE, counts = FALSE, r2 = FALSE, plot = TRUE) {
  
  # Safety checks
  if (!exists("MODEL_DIR")) {
    MODEL_DIR <- "../models/"
  }

  if (!dir.exists(MODEL_DIR)) {
    dir.create(MODEL_DIR)
  }

  if (nrow(data) == 0) {
    message("The data frame is empty.")
    return(NULL)
  }

  if (!responseVariable %in% names(data)) {
    message("Target column not found in the dataset.")
    return(NULL)
  }

  PCA_MODEL_PATH <- paste0(MODEL_DIR, "pca_model.rds")




  
  targetVariable <- data[[responseVariable]]

  predictorsRaw <- data[, !names(data) %in% responseVariable]
  numericPredictors <- predictorsRaw[, sapply(predictorsRaw, is.numeric)]
  
  if (ncol(numericPredictors) == 0) {
    message("No numeric predictors found for PCA.")
    return(NULL)
  }





  # --- HELPER: Check if cached model is stale ---
  shouldReRun <- function(filePath, currentLambdas) {
    if (!file.exists(filePath)) return(TRUE) # File doesn't exist
    
    cachedModel <- readRDS(filePath)
    
    # If we didn't save lambdas previously, we must re-run
    if (is.null(cachedModel$lambdas)) return(TRUE)
    
    # Check if lambdas are identical
    # We use isTRUE(all.equal(...)) to handle floating point comparisons
    return(!isTRUE(all.equal(cachedModel$lambdas, currentLambdas)))
  }

  if (shouldReRun(PCA_MODEL_PATH, lambdas)) {
    
    message("Running PCA (Lambdas changed or model missing)...")
    
    # Perform PCA
    pcaResult <- prcomp(numericPredictors, center = TRUE, scale. = TRUE)
    
    # Calculate variance explained by each component
    variableVariance <- pcaResult$sdev^2
    proportionVariance <- variableVariance / sum(variableVariance)
    cumulativeVariance <- cumsum(proportionVariance)
    
    # Determine how many components are needed to meet the threshold
    numComponents <- which(cumulativeVariance >= threshold)[1]
    
    # Handle edge case where 1 component is not enough or threshold is very low
    if (is.na(numComponents)) {
      numComponents <- length(cumulativeVariance)
    }
  
  




    # Print results
    message(paste("Number of components selected:", numComponents))
    message(paste("Cumulative variance explained:", round(cumulativeVariance[numComponents] * 100, 2), "%"), "\n")

    # Construct the Model
    selectedPcs <- as.data.frame(pcaResult$x[, 1:numComponents])
    
    # Combine the target variable with the selected principal components
    modelData <- cbind(Target = targetVariable, selectedPcs)
    
    # Build a linear regression model using the Principal Components
    pcaModel <- lm(Target ~ ., data = modelData)
    
    # Attach lambdas
    pcaModel$lambdas <- lambdas

    saveRDS(pcaModel, PCA_MODEL_PATH)

  } else {
    message("Loading cached PCA model...")
    pcaModel <- readRDS(PCA_MODEL_PATH)
  }




  # Output results
  pcaSummary <- summary(pcaModel)

  if (summarize) {
    print(pcaSummary)
  }

  count_vars <- function(model) {
    length(coef(model)) - 1
  }

  if (counts) {
    message("Variable Count:")
    message("\tPCA: ", count_vars(pcaModel),   " variables\n")
  }

  if (r2) {
    message("Adjusted R^2:")
    message("\tPCA: ", pcaSummary$adj.r.squared, "\n")
  }

  if (plot) {
    par(mfrow = c(2, 2), oma = c(0, 0, 3, 0))
    plot(pcaModel, sub.caption = "")
    mtext("PCA", outer = TRUE, cex = 1.5, font = 2)
    par(mfrow = c(1, 1))
  }

}