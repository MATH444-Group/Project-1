runBIC <- function(data, summarize = FALSE, counts = FALSE, r2 = FALSE, plot = TRUE) {

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





  bic_forward_summary <- summary(bic_forward_model)
  bic_backward_summary <- summary(bic_backward_model)

  if (summarize) {
    print(bic_forward_summary)
    print(bic_backward_summary)
  }

  count_vars <- function(model) {
    length(coef(model)) - 1   # subtract intercept
  }

  if (counts) {
    message("Variable Counts:")
    message("\tBIC Forward: ", count_vars(bic_forward_model),   " variables")
    message("\tBIC Backward: ", count_vars(bic_backward_model),  " variables\n")
  }

  if (r2) {
    message("Adjusted R^2:")
    message("\tBIC Forward: ", bic_forward_summary$adj.r.squared)
    message("\tBIC Backward: ", bic_backward_summary$adj.r.squared, "\n")
  }

  if (plot) {
    par(mfrow = c(2, 2), oma = c(0, 0, 3, 0))
    plot(bic_forward_model, sub.caption = "")
    mtext("BIC Forward Model", outer = TRUE, cex = 1.5, font = 2)
    plot(bic_backward_model, sub.caption = "")
    mtext("BIC backward Model", outer = TRUE, cex = 1.5, font = 2)
    par(mfrow = c(1, 1))
  }

}