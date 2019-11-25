.packageName <- 'cogmedia'

length_in_words = function(title_list) {
  return(lapply(title_list,function(x) {
    length(unlist(strsplit(x,' ')))
  }))
}

