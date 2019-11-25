.packageName <- 'cogmedia'

shift_date = function(n_days) {
  dt = as.Date(format(Sys.time(),'%Y-%m-%d'))+n_days
  return(dt)
}
