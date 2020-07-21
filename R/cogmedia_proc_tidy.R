#' Main CogMedia Code
#' 
#' @param content a data frame output from cogmedia_stories()
#' @param sentiments_data In tidytext format, sentiment data (internally sent via cogmedia_proc)
#' @return A list structure with basic NLP measures, such as frequency and sentiment

.packageName <- 'cogmedia'

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
