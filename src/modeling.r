DATA_DIR <- "../data/cleaned/"
DATA_FILE <- "cleaned train.csv"
DATA_PATH <- paste0(DATA_DIR, DATA_FILE)

if (!file.exists(DATA_PATH)) {
  stop(message(paste0("[[ CRITICAL ERROR ]]\nData \"", DATA_FILE, "\" not found in data directory \"", DATA_DIR, "\"\n")))
}

data <- read.csv(DATA_PATH)





library(MASS)

MODEL_FILE_DIR <- "../models/"

if(!dir.exists(MODEL_FILE_DIR)) {
  dir.create(MODEL_FILE_DIR)
}

MODEL_FILE_FORWARD_AIC <- paste0(MODEL_FILE_DIR, "aic_forward_selection_model.rds")
MODEL_FILE_BACKWARD_AIC <- paste0(MODEL_FILE_DIR, "aic_backward_selection_model.rds")

NULL_MODEL <- lm(SalePrice ~ 1, data = data)
fULL_MODEL <- lm(SalePrice ~ ., data = data)

if (!file.exists(MODEL_FILE_FORWARD_AIC)) {
  aic_forward_model <- stepAIC(NULL_MODEL,
    scope = list(lower = NULL_MODEL, upper = fULL_MODEL),
    direction = "forward",
    trace = FALSE
  )
  saveRDS(aic_forward_model, MODEL_FILE_FORWARD_AIC)
} else {
  aic_forward_model <- readRDS(MODEL_FILE_FORWARD_AIC)
}

if (!file.exists(MODEL_FILE_BACKWARD_AIC)) {
  aic_backward_model <- stepAIC(fULL_MODEL,
    direction = "backward",
    trace = FALSE
  )
  saveRDS(aic_backward_model, MODEL_FILE_BACKWARD_AIC)
} else {
  aic_backward_model <- readRDS(MODEL_FILE_BACKWARD_AIC)
}

summary(aic_forward_model)
summary(aic_backward_model)