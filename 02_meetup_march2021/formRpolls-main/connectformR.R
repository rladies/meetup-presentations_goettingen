
# packages needed install if not already installed
list.of.packages <- c("ggplot2", "cowplot", "dplyr", "tidytext", "tokenizers", "wordcloud", "kableExtra", "devtools")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
require(devtools)
if (!require("formr")) devtools::install_github("rubenarslan/formr")

library(formr)
formr_connect(email = 'youremail@emailprovider.de', password = 'yourpassword', host = "https://formr.org")
