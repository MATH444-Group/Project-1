DATA_DIR <- "../data/cleaned/"
DATA_FILE <- "cleaned train.csv"
DATA_PATH <- paste0(DATA_DIR, DATA_FILE)

MODEL_DIR <- "../models/"


if (!file.exists(DATA_PATH)) {
  stop(message(paste0("[[ CRITICAL ERROR ]]\nData \"", DATA_FILE, "\" not found in data directory \"", DATA_DIR, "\"\n")))
}

data <- read.csv(DATA_PATH)

source("reduction.r")
data <- dropUncorrelatedPredictors(data = data, responseVariable = "SalePrice")





source("aic.r")
runAIC(summarize = TRUE)