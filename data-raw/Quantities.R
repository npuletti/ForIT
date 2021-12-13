## code to prepare `Quantities` dataset goes here
Quantities <-
  tibble::tribble(
    ~quantity,                           ~quantity_definition,
    "vol", "volume of the stem and large branches [dm^3]",
    "dw1", "phytomass of the stem and large braches [kg]",
    "dw2",         "phytomass of the small branches [kg]",
    "dw3",                  "phytomass of the stump [kg]",
    "dw4",             "phytomass of the whole tree [kg]"
  )
# usethis::use_data(Quantities, overwrite = TRUE, internal = TRUE)
