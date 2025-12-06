runBIC <- function(summarize = FALSE, counts = FALSE) {

  library(MASS)

  if (!exists("MODEL_DIR")) {
    MODEL_DIR <- "../models/"
  }

  if(!dir.exists(MODEL_DIR)) {
    dir.create(MODEL_DIR)
  }

  # Setting up for BIC selection
  numberOfObservations <- nrow(data)
  k_bic <- log(numberOfObservations)

  BIC_FORWARD_MODEL_PATH  <- paste0(MODEL_DIR, "bic_forward_model.rds")
  BIC_BACKWARD_MODEL_PATH <- paste0(MODEL_DIR, "bic_backward_model.rds")

  NULL_MODEL <- lm(SalePrice ~ 1, data = data)
  fULL_MODEL <- lm(SalePrice ~ ., data = data)





  # Forward BIC selection
  if (!file.exists(BIC_FORWARD_MODEL_PATH)) {
    bic_forward_model <- stepAIC(
      NULL_MODEL,
      scope     = list(lower = NULL_MODEL, upper = fULL_MODEL),
      direction = "forward",
      k         = k_bic,
      trace     = FALSE
    )
    saveRDS(bic_forward_model, BIC_FORWARD_MODEL_PATH)
  } else {
    bic_forward_model <- readRDS(BIC_FORWARD_MODEL_PATH)
  }

  # Backward BIC selection
  if (!file.exists(BIC_BACKWARD_MODEL_PATH)) {
    bic_backward_model <- stepAIC(
      fULL_MODEL,
      direction = "backward",
      k         = k_bic,
      trace     = FALSE
    )
    saveRDS(bic_backward_model, BIC_BACKWARD_MODEL_PATH)
  } else {
    bic_backward_model <- readRDS(BIC_BACKWARD_MODEL_PATH)
  }





  if (summarize) {
    print(summary(bic_forward_model))
    print(summary(bic_backward_model))
  }

  count_vars <- function(model) {
    length(coef(model)) - 1   # subtract intercept
  }

  if (counts) {
    message("\nVariable Counts:\n")
    message("BIC Forward   :", count_vars(bic_forward_model),   "variables\n")
    message("BIC Backward  :", count_vars(bic_backward_model),  "variables\n")
  }

}