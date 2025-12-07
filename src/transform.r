library(caret)

applyBoxCoxTransform <- function(data, responseVariable, autoShift = TRUE) {
  
  # Safety check
  if (!responseVariable %in% names(data)) {
    stop("The response variable was not found in the dataframe.")
  }
  
  # Separate response and predictors
  responseData <- data[[responseVariable]]
  predictorData <- data[, setdiff(names(data), responseVariable)]
  
  # Isolate numeric predictors
  numericCols <- sapply(predictorData, is.numeric)
  numericPredictors <- predictorData[, numericCols]
  nonNumericPredictors <- predictorData[, !numericCols]
  
  # Shift past negative predictors
  if (autoShift) {
    for (colName in names(numericPredictors)) {
      colMin <- min(numericPredictors[[colName]], na.rm = TRUE)
      if (colMin <= 0) {
        offset <- abs(colMin) + 1
        numericPredictors[[colName]] <- numericPredictors[[colName]] + offset
      }
    }
  }
  
  # Apply Box-Cox
  # Safety check for negatives
  if (any(numericPredictors <= 0, na.rm = TRUE)) {
    stop("Data still contains non-positive values. Set autoShift = TRUE.")
  }
  
  transModel <- preProcess(numericPredictors, method = c("BoxCox"))
  transformedNumeric <- predict(transModel, numericPredictors)
  
  # Reconstruct Dataset
  if (ncol(nonNumericPredictors) > 0) {
    finalData <- cbind(transformedNumeric, nonNumericPredictors)
  } else {
    finalData <- transformedNumeric
  }
  
  # Re-attach the response variable
  finalData[[responseVariable]] <- responseData
  
  return(list(
    transformedData = finalData, 
    lambdas = transModel$bc
  ))
}