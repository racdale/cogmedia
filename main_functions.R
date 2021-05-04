cogmedia_sources = function(data,dt1=yesterday(),dt2=tomorrow()) {
  data_filtered = data[as.Date(data$story_date)>=dt1&as.Date(data$story_date)<=dt2,]
  print(nrow(data_filtered))
  tbl = table(data_filtered$source)
  return(data.frame(source=names(tbl),n_stories=as.numeric(tbl)))
}

tomorrow = function() {
  dt = shift_date(+1)
  return(dt)
}

yesterday = function() {
  dt = shift_date(-1)
  return(dt)
}

shift_date = function(n_days) {
  dt = as.Date(format(Sys.time(),'%Y-%m-%d'))+n_days
  return(dt)
}


length_in_words = function(title_list) {
  return(lapply(title_list,function(x) {
    length(unlist(strsplit(x,' ')))
  }))
}

# content a data frame output from cogmedia_stories()
# sentiments_data In tidytext format, sentiment data (internally sent via cogmedia_proc)
# return a list structure with basic NLP measures, such as frequency and sentiment
cogmedia_proc_tidy = function(content,sentiments_data) {
  
  tidy_stories = content %>%
    unnest_tokens(word,title)
  
  word_count_full = tidy_stories %>% group_by(url) %>% summarise(n=n(),.groups='rowwise')
  
  tidy_stories = tidy_stories %>% 
    anti_join(get_stopwords(),by="word")
  
  word_count_no_stops = tidy_stories %>% group_by(url) %>% summarise(n=n(),.groups='rowwise')
  
  freq_dist = tidy_stories %>% 
    count(word,sort=TRUE)
  
  sentiments = unique(sentiments_data$sentiment)
  
  sent_scores = c()
  for (sent in sentiments) {
    nrc_dat = sentiments_data %>% 
      filter(sentiment == sent)
    sent_scores = rbind(sent_scores,data.frame(sentiment=sent,
                                               percent=mean(tidy_stories$word %in% nrc_dat$word)))
  }
  
  return(list(freq_dist=freq_dist,
              source=table(content$long_name),
              sentiments=sent_scores,
              word_count_full=word_count_full,
              word_count_no_stops=word_count_no_stops))
  
}


# stories a data frame output from cogmedia_stories()
# aggregate If TRUE (default) average NLP measures; if FALSE, calculate and output per story
# return a list structure with basic NLP measures, such as frequency and sentiment
cogmedia_proc = function(stories,aggregate=TRUE) {
  # note: very early stage processor for basic nlp on headlines...
  
  require(tidytext)
  require(textdata)
  require(dplyr)
  
  sentiments_data = get_sentiments("nrc")
  
  if (aggregate) {
    res = cogmedia_proc_tidy(stories,sentiments_data)
  } else {
    proc_stories = vector("list",nrow(stories))
    print(paste('Processing',nrow(stories),'stories separately (aggregate=FALSE), may take a minute...'))
    
    for (i in 1:nrow(stories)) {
      print(i)
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


