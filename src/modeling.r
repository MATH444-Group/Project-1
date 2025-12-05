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

# Setting up for BIC selection
n_obs <- nrow(data)
k_bic <- log(n_obs)

MODEL_FILE_FORWARD_BIC  <- paste0(MODEL_FILE_DIR, "bic_forward_selection_model.rds")
MODEL_FILE_BACKWARD_BIC <- paste0(MODEL_FILE_DIR, "bic_backward_selection_model.rds")

# Forward BIC selection
if (!file.exists(MODEL_FILE_FORWARD_BIC)) {
  bic_forward_model <- stepAIC(
    NULL_MODEL,
    scope     = list(lower = NULL_MODEL, upper = fULL_MODEL),
    direction = "forward",
    k         = k_bic,
    trace     = FALSE
  )
  saveRDS(bic_forward_model, MODEL_FILE_FORWARD_BIC)
} else {
  bic_forward_model <- readRDS(MODEL_FILE_FORWARD_BIC)
}

# Backward BIC selection
if (!file.exists(MODEL_FILE_BACKWARD_BIC)) {
  bic_backward_model <- stepAIC(
    fULL_MODEL,
    direction = "backward",
    k         = k_bic,
    trace     = FALSE
  )
  saveRDS(bic_backward_model, MODEL_FILE_BACKWARD_BIC)
} else {
  bic_backward_model <- readRDS(MODEL_FILE_BACKWARD_BIC)
}

summary(bic_forward_model)
summary(bic_backward_model)

count_vars <- function(model) {
  length(coef(model)) - 1   # subtract intercept
}

print("\nVariable Counts:\n")
print("AIC Forward   :", count_vars(aic_forward_model),   "variables\n")
print("AIC Backward  :", count_vars(aic_backward_model),  "variables\n")
print("BIC Forward   :", count_vars(bic_forward_model),   "variables\n")
print("BIC Backward  :", count_vars(bic_backward_model),  "variables\n")