#' Main SINDy Code
#' 
#' @param dt1 'YYYY-MM-DD' format for date 1 of interval
#' @param dt2 'YYYY-MM-DD' format for date 2 of interval
#' @param api_key API key supplied by the CogMedia project
#' @return A data frame with sources, story counts, average social score, alexa rank, and partisanship

.packageName <- 'cogmedia'

cogmedia_sources = function(dt1=yesterday(),dt2=tomorrow(),api_key) {
  print(as.Date(dt1)-as.Date(dt2))
  url = 'https://co-mind.org/cogmedia/api-php-base?'
  url = paste(url,'f=sources&dt1=',urltools::url_encode(dt1),'&dt2=',urltools::url_encode(dt2),'&api_key=',api_key,sep='')
  sources = jsonlite::fromJSON(url)
  return(sources)
}


