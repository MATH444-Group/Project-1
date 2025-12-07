runAIC <- function(data, summarize = FALSE, counts = FALSE, r2 = FALSE, plot = TRUE) {

  library(MASS)

  if (!exists("MODEL_DIR")) {
    MODEL_DIR <- "../models/"
  }

  if (!dir.exists(MODEL_DIR)) {
    dir.create(MODEL_DIR)
  }

  AIC_FORWARD_MODEL_PATH <- paste0(MODEL_DIR, "aic_forward_model.rds")
  AIC_BACKWARD_MODEL_FILE <- paste0(MODEL_DIR, "aic_backward_model.rds")

  NULL_MODEL <- lm(SalePrice ~ 1, data = data)
  fULL_MODEL <- lm(SalePrice ~ ., data = data)





  # Forward AIC selection
  if (!file.exists(AIC_FORWARD_MODEL_PATH)) {
    aic_forward_model <- stepAIC(NULL_MODEL,
      scope     = list(lower = NULL_MODEL, upper = fULL_MODEL),
      direction = "forward",
      trace     = FALSE
    )
    saveRDS(aic_forward_model, AIC_FORWARD_MODEL_PATH)
  } else {
    aic_forward_model <- readRDS(AIC_FORWARD_MODEL_PATH)
  }



  # Backward AIC selection
  if (!file.exists(AIC_BACKWARD_MODEL_FILE)) {
    aic_backward_model <- stepAIC(fULL_MODEL,
      direction = "backward",
      trace     = FALSE
    )
    saveRDS(aic_backward_model, AIC_BACKWARD_MODEL_FILE)
  } else {
    aic_backward_model <- readRDS(AIC_BACKWARD_MODEL_FILE)
  }





  aic_forward_summary <- summary(aic_forward_model)
  aic_backward_summary <- summary(aic_backward_model)

  if (summarize) {
    print(aic_forward_summary)
    print(aic_backward_summary)
  }

  count_vars <- function(model) {
    length(coef(model)) - 1
  }

  if (counts) {
    message("Variable Counts:")
    message("\tAIC Forward: ", count_vars(aic_forward_model),   " variables")
    message("\tAIC Backward: ", count_vars(aic_backward_model),  " variables\n")
  }

  if (r2) {
    message("Adjusted R^2:")
    message("\tAIC Forward: ", aic_forward_summary$adj.r.squared)
    message("\tAIC Backward: ", aic_backward_summary$adj.r.squared, "\n")
  }

  if (plot) {
    par(mfrow = c(2, 2), oma = c(0, 0, 3, 0))
    plot(aic_forward_model, sub.caption = "")
    mtext("AIC Forward Model", outer = TRUE, cex = 1.5, font = 2)
    plot(aic_backward_model, sub.caption = "")
    mtext("AIC backward Model", outer = TRUE, cex = 1.5, font = 2)
    par(mfrow = c(1, 1))
  }

}