INFCvpe <-
function(spg, d, h, mod, freq, aggr=F) {
  
  aggr <- ifelse(sum(table(spg)>1)==0, F, aggr)
  
  if(missing(freq)) {
    cav <- data.frame(spg, d130=d, h_tot=h, frequency=rep(1,length(d)) )
  } else {
    cav <- data.frame(spg, d130=d, h_tot=h, frequency=freq)
  }
  
  grandezze <- data.frame(grandezza= c(
    "v: volume of the stem and large branches [dm^3]",
    "dw1: phytomass of the stem and large braches [kg]",
    "dw2: phytomass of the small branches [kg]",
    "dw3: phytomass of the stump [kg]",
    "dw4: phytomass of the whole tree [kg]"
  ))
  
  grandezze$cod <- substr(grandezze$grandezza,1,regexpr(":", grandezze$grandezza)-1)
  if (!(mod %in% grandezze$cod)) {cat("ERROR - Unrecognized esitimation quantity")}
  
  spl <- as.character(unique(cav$spg))
  
  # s <- spl[1]
  
  result <- NULL
  for (s in spl) {
    stats_s <- INFCstats[INFCstats$spg==s & INFCstats$mod==mod,]
    
    n_par <- stats_s$n_par
    b <- c(stats_s$b.1., stats_s$b.2.)
    b <- t(t(b))
    
    cav2 <- cav[cav$spg==s,]
    d2h <- with(cav2, d130^2 * h_tot * frequency)
    one <- rep(1, length(d2h))
    D_0 <- cbind(one, d2h)
    D_0_u <- one %*% D_0
    T_0 <- D_0_u %*% b
    if(aggr==F) T_0 <- D_0 %*% b
    
    if (n_par == 3) b[3] <- stats_s$b.3.
    b <- t(t(b))
    d130 <- cav2$d130
    d2h <- with(cav2, d130^2 * h_tot * frequency)
    one <- rep(1, length(d2h))
    if (n_par == 3) D_0 <- cbind(one, d2h, d130) # ho aggiunto un "if (n_par == 3)" per evitare l'incompatibilità
    D_0_u <- one %*% D_0
    T_0 <- D_0_u %*% b
    if(aggr==F) T_0 <- D_0 %*% b
    
    ##
    mvc <- NA
    if (n_par == 2) mvc <- matrix(c(stats_s$mvc.1., stats_s$mvc.3.,
                                    stats_s$mvc.3., stats_s$mvc.4.), 2, 2) # [i] row = [i] col
    
    if (n_par == 3) mvc <- matrix(c(stats_s$mvc.1., stats_s$mvc.4., stats_s$mvc.7.,
                                    stats_s$mvc.4., stats_s$mvc.5., stats_s$mvc.8.,
                                    stats_s$mvc.7., stats_s$mvc.8., stats_s$mvc.9.), 3, 3)
    
    sa2 <- stats_s$saq
    
    if (aggr==F) {Var_tot <- (D_0[1,] %*% mvc %*% t(t(D_0[1,]))) + (sa2*d2h^2) #rel. [22]
    } else {
      W_0 <- diag(x=d2h^2)
      Var_stima <- D_0_u %*% mvc %*% t(D_0_u)
      Var_resid <- one %*% W_0 %*% one * sa2
      Var_tot <- Var_stima + Var_resid
    }
    
    SEE <- sqrt(Var_tot)
    dof <- with(stats_s, n_oss-n_par)
    
    ##
    if(aggr==T){
      out <- data.frame(spg=s, mod=mod, T_0=round(T_0,1), N=sum(cav2$frequency), SEE, dof)
    } else {
      out <- data.frame(spg=cav2$spg, d130=cav2$d130, h_tot=cav2$h_tot, freq=cav2$frequency, mod=mod, T_0=round(T_0,1), SEE, dof)
    }
    
    result <- rbind(result, out)
    
  }
  result <- result[!duplicated(result), ]
  
  if(aggr==F) {
    result$key <- paste(result$spg, round(result$d130,0), round(result$h_tot,0),sep='-')
    
    result <- merge(result, INFCdomain, by = c("key", "key"), all.x=T)
    result$in.range <- as.character(result$in.range)
    result$in.range[is.na(result$in.range)] <- 'n'
    
    out.of.range <- result[result$in.range=='n',]
  }
  
  if(aggr==T) {
    cav$key <- paste(cav$spg, round(cav$d130,0), round(cav$h_tot,0),sep='-')
    
    cav <- merge(cav, INFCdomain, by = c("key", "key"), all.x=T)
    cav$in.range <- as.character(cav$in.range)
    cav$in.range[is.na(cav$in.range)] <- 'n'
    
    out.of.range <- cav[cav$in.range=='n',]
  }
  list(mainData = result, out.of.range=out.of.range)
}
