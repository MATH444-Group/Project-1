# options(warn = -1)

DATA_DIR <- "../data/cleaned/"
DATA_FILE <- "cleaned train.csv"
DATA_PATH <- paste0(DATA_DIR, DATA_FILE)

MODEL_DIR <- "../models/"


if (!file.exists(DATA_PATH)) {
  stop(message(paste0("[[ CRITICAL ERROR ]]\nData \"", DATA_FILE, "\" not found in data directory \"", DATA_DIR, "\"\n")))
}

data <- read.csv(DATA_PATH)

source("reduction.r")
reducedData <- dropUncorrelatedPredictors(data = data, responseVariable = "SalePrice")
reducederData <- dropHighCollinearPredictors(data = reducedData, responseVariable = "SalePrice")
reducedestData <- dropNonLinearPredictors(data = reducederData, responseVariable = "SalePrice")

source("transform.r")
transformation <- applyBoxCoxTransform(data = reducederData, responseVariable = "SalePrice")





message("******************************** Initial Model ********************************\n")
initialModel = lm(SalePrice ~ ., data = reducedestData)
# summary(initialModel)
par(mfrow = c(2, 2), oma = c(0, 0, 3, 0))
plot(initialModel, sub.caption = "")
mtext("Initial Model", outer = TRUE, cex = 1.5, font = 2)
par(mfrow = c(1, 1))

message("****************************** Transformed Model ******************************\n")
transformedModel = lm(SalePrice ~ ., data = transformation$transformedData)
# summary(transformedModel)
par(mfrow = c(2, 2), oma = c(0, 0, 3, 0))
plot(transformedModel, sub.caption = "")
mtext("Transformed Model", outer = TRUE, cex = 1.5, font = 2)
par(mfrow = c(1, 1))

message("************************************* AIC *************************************\n")
source("aic.r")
runAIC(
  data = transformation$transformedData, 
  lambdas = transformation$lambdas,
  counts = TRUE, 
  r2 = TRUE, 
  plot = TRUE
)

message("************************************* BIC *************************************\n")
source("bic.r")
runBIC(
  data = transformation$transformedData, 
  lambdas = transformation$lambdas, 
  counts = TRUE, 
  r2 = TRUE
)

message("************************************* PCA *************************************\n")
source("pca.r")
runPCA(
  data = transformation$transformedData, 
  responseVariable = "SalePrice", 
  lambdas = transformation$lambdas, 
  counts = TRUE, 
  r2 = TRUE
)
