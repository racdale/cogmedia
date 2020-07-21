#' Main CogMedia Code
#' 
#' @param stories a data frame output from cogmedia_stories()
#' @param aggregate If TRUE (default) average NLP measures; if FALSE, calculate and output per story
#' @return A list structure with basic NLP measures, such as frequency and sentiment

.packageName <- 'cogmedia'

cogmedia_proc = function(stories,aggregate=TRUE) {
  # note: very early stage processor for basic nlp on headlines...
  
  require(tidytext)
  require(textdata)
  require(dplyr)
  
  sentiments_data = get_sentiments("nrc")
  
  if (aggregate) {
    proc_stories = cogmedia_proc_tidy(stories,sentiments_data)
  } else {
    proc_stories = vector("list",nrow(stories))
    print(paste('Processing',nrow(stories),'stories separately (aggregate=FALSE), may take a minute...'))
    
    for (i in 1:nrow(stories)) {
      proc_stories[[i]] = cogmedia_proc_tidy(stories[i,],sentiments_data)
    }
    
    # messy, but setup to preserve list structure for output... TODO: improve dplyr/tidyr use
    sentiments_by_story = data.frame(do.call(rbind,lapply(proc_stories,function(x){
      t(x$sentiments$percent)
    })))
    colnames(sentiments_by_story)=proc_stories[[1]]$sentiments$sentiment
    
    full_word_count = do.call(rbind,lapply(proc_stories,function(x){
      t(x$word_count_full$n)
    }))
    no_stops_word_count = do.call(rbind,lapply(proc_stories,function(x){
      t(x$word_count_no_stops$n)
    }))
    word_counts = data.frame(n_full=full_word_count,
                             n_no_stops=no_stops_word_count)
    
    res = list(story_data=proc_stories,
               sentiments=sentiments_by_story,
               word_counts=word_counts)
  }
  return(res)
}
