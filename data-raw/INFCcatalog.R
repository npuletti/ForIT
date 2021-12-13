## code to prepare `INFCcatalog` dataset goes here

# Tabacchi G., Di Cosmo L., Gasparini P., Morelli S. (2011)
# Stima del volume e della fitomassa delle principali specie forestali italiane. Equazioni di
# previsione, tavole del volume e tavole della fitomassa arborea epigea.
# Consiglio per la Ricerca e la sperimentazione in Agricoltura, Unità di Ricerca per il
# Monitoraggio e la Pianificazione Forestale. Trento. 412 pp.

INFCcatalog <- tibble::tribble(
  # PARTE 1 – Metodi e risultati
  # PARTE 2 – Tavole del volume e della fitomassa
  #   SEZIONE A – CONIFERE
  ~pag,      ~n_oss,      ~n_par,           ~section,
  33L,          46L,          3L,          "Abete bianco",
  47L,          45L,          3L,          "Cipressi",
  61L,          45L,          3L,          "Larice",
  75L,          93L,          3L,          "Abete rosso",
  89L,          22L,          2L,          "Pino cembro",
  103L,          31L,          3L,          "Pino d\'Aleppo",
  117L,          50L,          2L,          "Pino laricio",
  131L,          63L,          3L,          "Pino nero",
  145L,          26L,          2L,          "Pino marittimo",
  159L,          23L,          2L,          "Pino domestico",
  173L,          43L,          2L,          "Pino silvestre",
  187L,          24L,          2L,          "Pini esotici",
  201L,          35L,          3L,          "Douglasia",
#  215L,          196L,         2L,          "Piccoli alberi di conifere",
#  not included (because non vey important dbh 1-15 htot 2-15
  #   SEZIONE B - LATIFOGLIE
  231L,          37L,          2L,          "Aceri",
  245L,          35L,          3L,          "Ontani",
  259L,          65L,          2L,          "Carpini",
  273L,          85L,          3L,          "Castagno",
  287L,          24L,          2L,          "Eucalitti",
  301L,          91L,          2L,          "Faggio",
  315L,          33L,          2L,          "Frassini",
  329L,          88L,          2L,          "Cerro",
  343L,          83L,          3L,          "Leccio",
  357L,          117L,          3L,          "Roverella",
  371L,          50L,          3L,          "Robinia",
  385L,          38L,          2L,          "Salici",
  399L,          22L,          3L,          "Altre latifoglie")

# usethis::use_data(INFCcatalog, overwrite = TRUE, internal = TRUE)
