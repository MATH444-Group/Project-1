runAIC <- function(summarize = FALSE) {

  library(MASS)

  if (!exists("MODEL_DIR")) {
    MODEL_DIR <- "../models/"
  }

  if (!dir.exists(MODEL_DIR)) {
    dir.create(MODEL_DIR)
  }

  AIC_FORWARD_MODEL_PATH <- paste0(MODEL_DIR, "aic_forward_selection_model.rds")
  AIC_BACKWARD_MODEL_FILE <- paste0(MODEL_DIR, "aic_backward_selection_model.rds")

  NULL_MODEL <- lm(SalePrice ~ 1, data = data)
  fULL_MODEL <- lm(SalePrice ~ ., data = data)





  if (!file.exists(AIC_FORWARD_MODEL_PATH)) {
    aic_forward_model <- stepAIC(NULL_MODEL,
      scope = list(lower = NULL_MODEL, upper = fULL_MODEL),
      direction = "forward",
      trace = FALSE
    )
    saveRDS(aic_forward_model, AIC_FORWARD_MODEL_PATH)
  } else {
    aic_forward_model <- readRDS(AIC_FORWARD_MODEL_PATH)
  }



  if (!file.exists(AIC_BACKWARD_MODEL_FILE)) {
    aic_backward_model <- stepAIC(fULL_MODEL,
      direction = "backward",
      trace = FALSE
    )
    saveRDS(aic_backward_model, AIC_BACKWARD_MODEL_FILE)
  } else {
    aic_backward_model <- readRDS(AIC_BACKWARD_MODEL_FILE)
  }





  if (summarize) {
    print(summary(aic_forward_model))
    print(summary(aic_backward_model))
  }

}