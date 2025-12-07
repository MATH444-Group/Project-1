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
reducedData <- dropHighCollinearPredictors(data = reducedData, responseVariable = "SalePrice")




message("************************************* AIC *************************************\n")
source("aic.r")
runAIC(data = reducedData, counts = TRUE, r2 = TRUE, plot = TRUE)

message("************************************* BIC *************************************\n")
source("bic.r")
runBIC(data = reducedData, counts = TRUE, r2 = TRUE)

message("************************************* PCA *************************************\n")
source("pca.r")
runPCA(data = reducedData, responseVariable = "SalePrice", counts = TRUE, r2 = TRUE)