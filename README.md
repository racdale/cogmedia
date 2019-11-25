# CogMedia API

CogMedia's core data is available for download in throttled buckets. In order to obtain a free API key, please visit [co-mind.org/cogmedia](https://co-mind.org/cogmedia). 

### Examples

With the API, you can summon data right inside R, in the following way. The API offers two main functions. One extracts news sources (e.g., LA Times), while the second extracts the stories themselves.

```R

source_counts = cogmedia_sources(api_key='XXX');

stories = cogmedia_data(api_key='XXX',
	dt1='2019-01-01', dt2='2019-02-01',
	source='New York Times', sort_by='social_score');

```

### Read real-time news in R!

You can read the news in R! Using `crayon`, we format news stories in your console so you can see real-time updates to the news. Simply set `cogmedia_data` parameter `peruse` to `TRUE`.

```R

stories = cogmedia_data(api_key='XXX', n_stories=20, peruse=TRUE);

```

Currently, the following three commands can be used at the prompt: describe X, goto X, q. X is the news story number as listed by `cogmedia_data` output.

### Installation

On occasion this version on GitHub will go out of alignment before we do a CRAN update. If this happens you can install from the repository this way:

```R

install.packages('devtools')

devtools::install_github('racdale/cogmedia-api')

```

