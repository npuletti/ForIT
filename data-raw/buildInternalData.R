# *** Get ForIT database tables ***
source("./data-raw/INFCspecies.R")
source("./data-raw/INFCcatalog.R")
source("./data-raw/Quantities.R")

source("./data-raw/INFCparam_as_table.R") #  produces INFCparam0
require(Matrix)
library(tidyverse)
INFCparam <- INFCparam0 %>%   # transforms to INFCparam
  tidyr::fill(pag) %>%        # riempie le caselle vuote con valori soprastanti
  dplyr::mutate(pag = as.integer(pag)) %>%
  dplyr::inner_join(INFCcatalog %>% dplyr::select(pag, n_par)) %>%
    dplyr::mutate(bm = purrr::pmap(list(n_par, b_1, b_2, b_3),
                                 function(n, b0, b1, b2) {
                                   if (n == 2)   x <- array(c(b0, b1), dim = c(n, 1)) else
                                     if (n == 3) x <- array(c(b0, b1, b2), dim = c(n, 1)) else
                                       x <- NULL
                                 }),
                  vcm = purrr::pmap(list(n_par, vcm_1.1, vcm_2.1, vcm_2.2, vcm_3.1, vcm_3.2, vcm_3.3),
                                  function(n, m1.1, m2.1, m2.2, m3.1, m3.2, m3.3) {
                                    if (n == 2)   x <- c(m1.1, m2.1, m2.2) else
                                      if (n == 3) x <- c(m1.1, m2.1, m2.2, m3.1, m3.2, m3.3) else
                                        x <- NULL
                                      return(new("dspMatrix", Dim = as.integer(c(n,n)), x = x))
                                  })
  ) %>%
  dplyr::select(pag, quantity, wrv, bm, vcm)

source("./data-raw/INFCdomains-as_txt_matrices.R")
# Legge il testo, interpreta la matrice, produce la rappresentazione come
# CompactDataFrame
dom_mat2cdf <- function(mat) {
  read.table(header = T, skip = 1, row.names = NULL, text = mat) %>%
    dplyr::rename(dbh.cm = X.1) %>%
    dplyr::mutate(dbh.cm = as.numeric(stringr::str_replace(dbh.cm, "-", ""))) %>%
    tidyr::pivot_longer(-dbh.cm, names_to = "htot.m", values_to = "dom" ) %>%
    dplyr::filter(dom == 11) %>%
    dplyr::mutate(htot.m = as.numeric(stringr::str_extract(htot.m, "[[:digit:]]{1,}"))) %>%
    dplyr::group_by(htot.m) %>%
    dplyr::summarise(
      dbh.min = min(dbh.cm),
      dbh.max = max(dbh.cm ))
}
INFCf_domains <- dom_mat %>%
  dplyr::mutate(pag = as.integer(pag)) %>%
  dplyr::mutate(cdf = purrr::map(mat, dom_mat2cdf)) %>%
  dplyr::select(-mat) %>%
  tidyr::unnest(cols = c(cdf))

# *** ForIT_test_data ***
source("./data-raw/ForIT_test_data.R")

# *** Auxiliary dataframe for function 'INFCaccuracyPlot0' ***
# 'Populate-INFC_CVgrid.R' creates the dataframe but !! it takes more than 30 min!!
# If the 'cache_file' exists we will just load it, otherwise it will be generated.
cache_file = "./data-raw/INFC_CVgrid_un.rda"
if(!file.exists(cache_file)) {
  source("./data-raw/Populate_INFC_CVgrid.R")
  INFC_CVgrid <- Populate_INFC_CVgrid()
  save(INFC_CVgrid, file = cache_file,
       compress = "xz", compression_level = 9)
  cat('Size of "', cache_file, '": ', file.size(cache_file),
      sep ="", " (", file.mtime(cache_file) %>% format(), ")")
  # Size of "./data-raw/INFC_CVgrid_un.rda": 2979952 (2021-07-12 16:19:59)
} else {
  load(cache_file)
}

usethis::use_data(
  INFCspecies,
  INFCcatalog,
  INFCf_domains,
  Quantities,
  INFCparam,
  INFC_CVgrid,
  ForIT_test_data,
  overwrite = TRUE,
  internal = FALSE
)

rm(list = c("dom_mat", "INFCparam0")) #rimuove oggetti intermedi
