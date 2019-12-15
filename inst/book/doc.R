## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  echo = FALSE,
  message = FALSE,
  error = FALSE,
  warning = FALSE,
  collapse = TRUE,
  comment = "#>"
)

## ----getwd--------------------------------------------------------------------
# print(getwd())
# devtools::load_all()
# figs <- system.file("vignettes/figures", package="vgnttr")
figs <- "figures"
fig1 <- file.path(figs, "topicterms.png")
# print(fig1)

## ----t-97, fig.pos="H", fig.cap="\\label{fig:topic97}Most relevant terms of topic 97", fig.align="c", out.width = "100%"----
knitr::include_graphics(fig1)

