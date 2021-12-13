# Populate CV grids to speed up standard accuracy plots production

# Packages should be of the minimum necessary size. Reasonable compression should be used for data (not just .rda files) and PDF documentation: CRAN will if necessary pass the latter through qpdf.
# As a general rule, neither data nor documentation should exceed 5MB (which covers several books). A CRAN package is not an appropriate way to distribute course notes, and authors will be asked to trim their documentation to a maximum of 5MB.
#
# Where a large amount of data is required (even after compression), consideration should be given to a separate data-only package which can be updated only rarely (since older versions of packages are archived in perpetuity).

Populate_INFC_CVgrid <- function() {
  INFCcatalog %>%
    select(pag) %>%
# testing option
#    slice_head(n = 3) %>%
    inner_join(INFCspecies %>%
                 select(pag, EPPOcode),
               by = "pag") %>%
    group_by(pag) %>%
    summarise(EPPOcode = first(EPPOcode),
              .groups = "drop") %>%
    inner_join(Quantities %>% select(quantity), by = character()) %>%
#    slice_head(n = 2) %>%
# testing option end
    mutate(grid.k = pmap(list(pag, EPPOcode, quantity), compute_grid0)) %>%
    select(-EPPOcode) %>%
    unnest(cols = c(grid.k)) %>%
    return()
}
