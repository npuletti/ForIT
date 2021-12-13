tst <- dplyr::tribble(
  ~UC, ~specie, ~d130, ~h_dendro,
  # Example data in Tabacchi et al. (2011) pag. 25
  "U1","ACROP",10,7,
  "U1","ACROP",15,9,
  "U1","ACROP",20,12,
  "U1","ACROP",30,20,
  "U1","ACROP",32,21,
  "U1","ACROP",24,18,
  "U1","ACROP",36,21,
  "U1","ACROP",40,22,
  "U1","ACROP",8,8,
  "U1","ACROP",18,12,

  # Example continuation, pag. 27
  "U2","ABIAL",38,21,
  "U2","ABIAL",52,28,
  "U2","FAUSY",25,16,
  "U2","FAUSY",30,18,
  "U2","FAUSY",12,10,

  # Extra line, to test 'out of domain'
  "U2","ABIAL",5,32)

tst %>%
  dplyr::filter(!(d130 == 5 & h_dendro == 32)) %>%
  dplyr::group_by(specie) %>%
  INFCvpe_summarise("specie", "d130", "h_dendro") %>%
  dplyr::ungroup() %>%
  dplyr::mutate(specie = factor(specie,
                         levels = c("ACROP", "ABIAL", "FAUSY"),
                         labels = c("aceri", "abete bianco", "faggio"),
                         ordered = TRUE),
                dplyr::across(c("est", "cihw"), ~round(.x, 1))
         ) %>%
  dplyr::select(specie, est, cihw) %>%
  dplyr::arrange(specie) %>%
  t()
# ForIT (ver 2) output
# specie "aceri"  "abete bianco" "faggio"
# est    "4623.0" "4044.2"       "1079.4"
# cihw   "567.5"  "661.2"        "275.4"

# In (Tabacchi et al., 2011, 'Tabella 2')
# specie "aceri"  "abete bianco" "faggio"
# est    "4623.0" "4044.2"       "1079.4"
# cihw   "567.4"  "662.4"        "279.2"

# Using 'INFCvpe_summarise()'
tst %>%
  INFCvpe_summarise("specie", "d130", "h_dendro", quantity = c("vol", "dw4"))

tst %>%
  dplyr::mutate(cld = ceiling(d130/5)*5) %>%
  dplyr::group_by(UC, specie, cld) %>%
  INFCvpe_summarise("specie", "d130", "h_dendro")

tst %>%
  dplyr::group_by(UC) %>%
  INFCvpe_summarise("specie", "d130", "h_dendro", quantity = "dw4")

# Using 'INFCvpeSUM' aggregation functions
tst %>%
  dplyr::group_by(UC) %>%
  dplyr::summarise(
    n_stems = dplyr::n(),
    OoD = INFCvpe_OutOfDomain(specie, d130, h_dendro),
    dw4 = INFCvpe_sum(specie, d130, h_dendro, quantity = "dw4"),
    dw4_ConfInt = INFCvpe_ConfInt(specie, d130, h_dendro, quantity = "dw4")
  )

tst %>%
  dplyr::group_by(UC) %>%
  dplyr::summarise(
    n_stems = dplyr::n(),
    OoD = INFCvpe_OutOfDomain(specie, d130, h_dendro),
    vol = INFCvpe_sum(specie, d130, h_dendro),
    vol_ConfInt = INFCvpe_ConfInt(specie, d130, h_dendro)
  )
rm(tst)
