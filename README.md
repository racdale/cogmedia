# CogMedia Function Library

CogMedia's core dataset is available for download on the main site. Please visit [co-mind.org/cogmedia](https://co-mind.org/cogmedia). 

With the function library, you can process CogMedia data batches inside R. Below are some examples that summarize news sources and carry out elementary NLP on headlines.

```R

library(jsonlite)

cogmedia_stories = fromJSON(fileName) 

cogmedia_sources = cogmedia_sources(cogmedia_stories,
                                    dt1='2020-01-01',
                                    dt2='2021-12-31');

process_headlines = cogmedia_proc(cogmedia_stories[1:1000,])

```

