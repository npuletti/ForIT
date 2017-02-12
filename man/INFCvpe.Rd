\name{INFCvpe}
\alias{INFCvpe}
\title{Volume and Phytomass Estimates}
\description{
Estimate tree volume and phytomass per species from stem diameter at 1.3 m
height (DBH) and total height (HT)
}
\usage{
INFCvpe(spg, d, h, mod, freq, aggr = F)
}

\arguments{
  \item{spg}{a string or factor indicating the species. See documentation of \code{INFCstats} for allowed codes}
  \item{d}{a value or vector indicating the stem diameter at 1.3 m height (DBH) [cm]}
  \item{h}{a value or vector indicating the total stem height (HT) [m]}
  \item{mod}{a character: \emph{v} for volume of the stem and large branches, \emph{dw1} for phytomass of the stem and large braches, \emph{dw2} for phytomass of the small branches, \emph{dw3} for phytomass of the stump, \emph{dw4} for phytomass of the whole tree}
  \item{freq}{the number of trees of the same \code{spg} with equal DBH and HT}
  \item{aggr}{a flag allowing estimates aggregated at \code{spg} level (when aggr is \code{TRUE}) or at tree level (when aggr is \code{FALSE})}
}
\details{

}
\value{

Returns a \code{list} with the following objects: \cr
\item{$mainData }{a \code{data.frame} with the following columns
\tabular{ll}{ \code{spg} \tab a string with the species group code \cr \code{d130} \tab a value indicating the stem diameter at 1.3 m height (DBH) [cm] \cr
\code{h_tot} \tab a value indicating the total stem height (HT) [m]\cr \code{freq}\tab the number of trees of the same \code{spg} with equal DBH and HT\cr \code{mod} \tab a character, the same as \code{mod} in arguments. \cr \code{T_0}\tab a value of the estimates for \code{mod} value.  \code{v} is expressed in \emph{dm^3} while \code{dw1}, \code{dw2}, \code{dw3}, \code{dw4} are expressed in
\emph{kg}; \cr \code{SEE}\tab a value of Standard Error of the Estimates \cr
\code{dof} \tab the degree of freedom \cr \code{in.range} \tab tree inside (\code{y}) or out of the range (\code{n}) of the sampled trees in Gasparini and
Tabacchi (2011)\cr } } \item{out.of.range}{a \code{data.frame} listing the
trees out of the range of application (domain)}

}
\references{
Gasparini, P., Tabacchi, G.(eds), 2011. \emph{L'Inventario
Nazionale delle Foreste e dei serbatoi forestali di Carbonio INFC 2005.
Secondo inventario forestale nazionale italiano. Metodi e risultati}.
Edagricole. 653 pp. [ITA, ita]

Tabacchi G., Di Cosmo L., Gasparini P., Morelli S., 2011a. \emph{Stima
del volume e della fitomassa delle principali specie forestali italiane.
Equazioni di previsione, tavole del volume e tavole della fitomassa arborea
epigea. Stima del volume e della fitomassa delle principali specie
forestali italiane. Equazioni di previsione, tavole del volume e tavole
della fitomassa arborea epigea}. 412 pp. [ITA, ita]

Tabacchi G., Di Cosmo L., Gasparini P., 2011b. \emph{Aboveground tree
volume and phytomass prediction equations for forest species in Italy}.
European Journal of Forest Research 130: 6 911-934 [ENG, eng]
}
\author{
Nicola Puletti \email{nicola.puletti@gmail.com}, Roberto Scotti
}

\examples{
# one single tree
INFCvpe('Acca', 22, 14, mod='v', freq=2, aggr=FALSE)

# a list with ten trees of the same specie
INFCvpe(rep('Acca',10),d=c(10,15,20,30,32,24,36,40,8,18),
    h=c(7,9,12,20,21,18,21,22,8,12), mod='v', aggr=TRUE)

# a list of different species
species <- rep(c('Abal','Piab'),2)
dbh <- c(10,41,20,30)
heigths <- c(12,14,13,15)
frequences <- c(2,6,5,4)
data.frame(species, dbh, heigths, frequences)

# single-tree estimates
INFCvpe(species, dbh, heigths, mod='v', frequences, aggr=FALSE)

# estimates aggregated at species level
INFCvpe(species, dbh, heigths, mod='v', frequences, aggr=TRUE)
}
