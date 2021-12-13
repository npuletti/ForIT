<!-- README.md is generated from README.Rmd. Please edit that file -->

...WORK IN PROGRESS...


# ForIT

![license](https://img.shields.io/badge/Licence-GPL--3-blue.svg)

<!-- badges: start -->
<img align="right" width="299" height="427" src= "/uploads/205e0ae403c63c2c9713a55e55961543/LOGO_ForIT_def.png">
<!-- badges: end -->

Using data collected during the 2nd Italian National Forest Inventory (2005) tree volume and aboveground phytomass
prediction equations were produced.
These equations allow the unbiased prediction of the above mentioned quantities (tree volume and aboveground phytomass) over 
for the most important tree species or groups of species in Italy. 
The independent variables used in the model are the diameter-at-breast-height ($`dbh`$) and 
the total tree height ($`h_{tot}`$). The general model formulation adopted is the following:

``` math
{y_0 = b_0 + b_1 × dbh^2 × h_{tot} + b_2 × dbh}
```

where $`y_0`$ is the volume or AGB phytomass.

The `ForIT` package was built for a direct use of such volume and phytomass models in the R environment.


### Package installation

You can install the version under developement of `ForIT` using:

``` r
devtools::install_gitlab("NuoroForestrySchool/forit")  
```

### Detailed description with examples

``` r
library(tidyverse)
library(ForIT)
```

In summary, three main sections can be :
1\) Functions for estimating tree quantities, for each single tree or for groups of species;  
2\) A section on tabulation used to obtain the volume or pythomass tables as `data.frame` (by the `INFCtabulate()` function);  
3\) Functions (`INFCaccuracyPlot0()` and `INFCaccuracyPlot()`) to graphically evaluate the estimated accuracy.  

As general note, it is important to underline that the 'tree species codes' used by ForIT are the “EPPO codes”: see <https://gd.eppo.int> for 
more info on EPPO project and `data(INFCspecies)` for a complete list of species used in this package.  


#### 1\) Volume and AGB tree estimates

Single tree estimates can be performed using the `INFCvpe()` function.

Otherwise, if the user is interested on estimates for groups of trees must refers to the `INFCvpeSUM` family of functions.


##### 1.1 - Single tree estimates

Here following we present an example for the estimation of one *Acer
campestre* tree (EPPO code is ‘ACRCA’) with diameter-at-breast-height
equal to 22 and 14 meters height.

``` r
vol <- INFCvpe("ACRCA", dbh.cm = 22, htot.m = 14)
```

The default estimated quantity is volume (`quantity = "vol"`). In this
specific case the estimated volume is 252.96 dm^{3}.

``` r
round(vol,2)
```

`[1] 252.96`

Alternative quantities can be visualized using the R command
``` r 
ForIT::Quantities
```

    -   quantity    quantity_definition
    1   vol         volume of the stem and large branches [dm^3]
    2   dw1         phytomass of the stem and large braches [kg]
    3   dw2         phytomass of the small branches [kg]
    4   dw3         phytomass of the stump [kg]
    5   dw4         phytomass of the whole tree [kg]

The function offers accuracy estimates for the selected quantity. 
All the quantities referred to phytomass are expressed in kg. ** ATTENZIONE: SI TRATTA DI Kg O DI Mg? Con ForIT::Quantities viene fuori che sono Kg ma io ho ricordo di Mg: verificare **

`Var_ea` variance for an estimated average;  
`Var_ie` variance for an individual estimate;  
`InDomain` logical indicating whether the (dbh, htot) point lies out of
the domain explored by the experimental data (see `INFCtabulate()`).  

`attr(,"wrv") [1] 2.271e-05`  
`attr(,"Var_ea") [1] 33.17182`  
`attr(,"Var_ie") [1] 1075.883`  
`attr(,"InDomain") [1] TRUE`

##### 1.2 - Estimates for groups of trees
Cumulative estimation of the volume or phytomass of groups of trees is just the summation of the values computed with INFCvpe(), but the computation of accuracy estimates is improved using these summation functions.

Two approaches are available.

##### 1.2.1 - Via `INFCvpe_summarise()`

It returns a dataframe (tibble) with the grouping columns defined with group_by(), and other columns related to selected options.

##### 1.2.2 - Within a standard `summarise()`
 by the `INFCvpe_SUM` function
The functions of this family return a numeric vector, aggregating rows within the same group.
* `INFCvpe_sum()` returns the sum of the estimated quantities;
* `INFCvpe_ConfInt()` returns 'confidence interval half width';
* `INFCvpe_OutOfDomain()` returns the number of 'out of domain' (dhb, h_tot) pairs included in the summation.

Copy and paste `?ForIT::INFCvpeSUM` in your RStudio console for more details on the function of this family.


#### 2\) `INFCtabulate`

Volume and phytomass functions are tabulated in Tabacchi et al. (2011a). Printed numbers serve as reference to verify that coded functions return expected results and, more specifically, empty spaces in the printed tables signal function applicability domain.  
In other words, measurement data used to estimate function coefficients values, cover only the portion of the (dbh, htot) plane where numbers are printed.

`INFCtabulate("ACRCA")`

    -    #5   #8    #11   #14   #17    #20    #23
    #5   6.3  9.1    NA    NA    NA     NA     NA
    #10 20.2 31.4  42.5    NA    NA     NA     NA
    #15   NA 68.4  93.5 118.5    NA     NA     NA
    #20   NA   NA 164.9 209.3 253.8  298.3     NA
    #25   NA   NA    NA 326.2 395.7  465.2     NA
    #30   NA   NA    NA 468.9 569.0  669.2  769.3
    #35   NA   NA    NA    NA 773.9  910.2 1046.5
    #40   NA   NA    NA    NA    NA 1188.3 1366.3

Copy and paste `?ForIT::INFCtabulate` in your RStudio console for more details.


#### 3\) Graphical evaluation of estimates accuracy and reliability

The tabulation described in `§2` covers a limited region of the `dbh` by `h_tot` rectangle.  
This region is the "domain" of the reliable estimates, based on the distribution of the sample trees used to calibrate the functions. The coefficient of variation (CV = standard_deviation / estimate) is computed and plotted (as 'filled contours') for the whole rectangular area, the limits of the region of reliable estimates (the "domain"), is superimposed as a light coloured line.
Function output is a `ggplot` object that can be used by its self or as a backgrund on top of which the user can plot his/her data to verify eventual accuracy or reliability problems.

Two functions are available.

`INFCaccuracyPlot0()` - produces, much faster, the plots at the finest resolution, using pre-calculated values stored in a specific auxiliary dataframe (see INFC_CVgrid), necessarily leaving less customization freedom.

`INFCaccuracyPlot0("LAXDE")`  

<img width="840" height="560" src= "/uploads/5b6b774bfd224abf5ba416c347273709/laxde.png">
   

`INFCaccuracyPlot()` - allows the plots to be fully customized but, beware, all values required for the 'fill' will be computed and, at finer resolution, the process can be slow.

`INFCaccuracyPlot("ABIAL", ie.Var = T, plot.est = T, cv.ul = .15, fixed = F)`  

<img width="840" height="560" src= "/uploads/cd82a3b8c9ca8599dab3fbc39150f341/ABIAL.png">


#### References

Gasparini, P., Tabacchi, G. (eds), 2011. L’Inventario Nazionale delle
Foreste e dei serbatoi forestali di Carbonio INFC 2005. Secondo
inventario forestale nazionale italiano. Metodi e risultati. Edagricole.
653 pp. 

Tabacchi G., Di Cosmo L., Gasparini P., Morelli S., 2011. Stima del
volume e della fitomassa delle principali specie forestali italiane.
Equazioni di previsione, tavole del volume e tavole della fitomassa
arborea epigea. Stima del volume e della fitomassa delle principali
specie forestali italiane. Equazioni di previsione, tavole del volume e
tavole della fitomassa arborea epigea. 412 pp. 

Tabacchi G., Di Cosmo L., Gasparini P., 2011. Aboveground tree volume
and phytomass prediction equations for forest species in Italy. European
Journal of Forest Research 130: 6 911-934.

PS: You’ll still need to render `README.Rmd` regularly, to keep
`README.md` up-to-date. `devtools::build_readme()` is handy for this.
You could also use GitHub Actions to re-render `README.Rmd` every time
you push. An example workflow can be found here:
<https://github.com/r-lib/actions/tree/master/examples>.
