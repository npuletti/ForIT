#' 'ForIT'-package Database - Ver.2
#- (https://stackoverflow.com/questions/57390342/use-roxygen2-to-document-multiple-datasets-in-a-single-documentation-object)
#- ATTENZIONE rivedere https://r-pkgs.org/data.html?q=data#data-extdata 14.1.1
#'
#' The package exposes 5 tightly interconnected tibbles:\cr
#' \code{INFCspecies}, \code{INFCcatalog}, \code{Quantities}, \code{INFCparam}, \code{INFCf_domains}
#' \if{html}{\figure{ForIT_DBschema.png}{options: width="75\%" alt="Figure: ForIT-DBschema"}}
#' \if{latex}{\figure{ForIT_DBschema.png}{options: width=7cm}}\cr
#' **Tables columns** \cr
#' \code{INFCspecies}
#' \itemize{
#' \item \code{EPPOcode [PK]}: species code, adopting \href{https://gd.eppo.int/search}{EPPO} database
#' \item \code{pag}: section page number
#' \item \code{PrefName}: EPPO preferred name for the species
#' }
#' \code{INFCcatalog}
#' \itemize{
#' \item \code{pag [PK]}: section page number in the original reference (Tabacchi et al., 2011a)
#' \item \code{n_oss}: number of sample trees for the section
#' \item \code{n_par}: number of parameters in the equations for the section
#' \item \code{section}: section name (species or species group)
#' }
#' \code{Quantities}
#' \itemize{
#' \item \code{quantity [PK]}: code of the estimated quantity
#' \item \code{quantity_definition}: estimated quantity definition and measurement units
#' }
#' \code{INFCparam}
#' \itemize{
#' \item \code{pag [PK]}: section page number
#' \item \code{quantity [PK]}: code of the estimated quantity (see Quantities)
#' \item \code{wrv}: weighted residual variance
#' \item \code{bm}: functions coefficients (a list of arrays)
#' \item \code{vcm}: variance covariance matrices (a list of 'dspMatrix')
#' }
#' \code{INFCf_domains}
#' \itemize{
#' \item \code{pag [PK]}: section page number
#' \item \code{htot.m [PK]}: tree heigh class \[m\] (class width 1 m)
#' \item \code{dbh.min}: minimum tree diamter class \[cm\] (class width 1 cm)
#' \item \code{dbh.max}: maximum tree diamter class \[cm\] (class width 1 cm)
#' }
#'
#' Columns \code{bm} and \code{vcm} are lists, the dimensions of the arrays and
#'      matrices they store vary depending on \code{n_par}.\cr
#' Matrices in \code{vcm} are symmetric, stored as "dspMatrix" class objects.\cr
#' Database schema is defined, verivied and illustrated using package \code{dm}
#' ```
#' library(dm)
#' ForIT_DB <- dm(INFCcatalog,
#'                INFCspecies,
#'                Quantities,
#'                INFCparam,
#'                INFCf_domains) %>%
#'   dm_add_pk(INFCcatalog, pag, check = TRUE) %>%
#'
#'   dm_add_pk(INFCspecies, EPPOcode, check = TRUE) %>%
#'   dm_add_fk(INFCspecies, pag, INFCcatalog, check = TRUE) %>%
#'
#'   dm_add_pk(Quantities, quantity, check = TRUE) %>%
#'
#'   dm_add_pk(INFCparam, c(pag, quantity), check = TRUE) %>%
#'   dm_add_fk(INFCparam, pag, INFCcatalog, check = TRUE) %>%
#'   dm_add_fk(INFCparam, quantity, Quantities, check = TRUE) %>%
#'
#'   dm_add_pk(INFCf_domains, c(pag, htot.m), check = TRUE) %>%
#'   dm_add_fk(INFCf_domains, pag, INFCcatalog, check = TRUE)
#'
#' dm_examine_constraints(ForIT_DB)
#'
#' dm_draw(ForIT_DB, rankdir = "BT", view_type = "all", column_types = T)
#' ```
#'
#' @name ForIT_DataBase
#' @keywords datasets
NULL

#' @rdname ForIT_DataBase
"INFCspecies"
#'
#' @rdname ForIT_DataBase
"INFCcatalog"
#'
#' @rdname ForIT_DataBase
"Quantities"
#'
#' @rdname ForIT_DataBase
"INFCparam"
#'
#' @rdname ForIT_DataBase
"INFCf_domains"
#'
