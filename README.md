# CogMedia API

CogMedia's core data is available for download in throttled buckets. In order to obtain a free API key, please visit [co-mind.org/cogmedia](https://co-mind.org/cogmedia). 

### Examples

With the API, you can summon data right inside R, in the following way. The API offers two main functions. One extracts news sources (e.g., LA Times), while the second extracts the stories themselves.

```R

source_counts = cogmedia_sources(api_key='API_KEY')

stories = cogmedia_data(api_key='API_KEY',
	dt1='2019-06-10', dt2='2019-06-20',
	source='New York Times', sort_by='social_score')

```

CogMedia's API contains some rudimentary applied NLP via tidytext and other resources. The function `cogmedia_proc` can be applied to output from `cogmedia_data` and it will return a list structure with various details.

```R

processed_info = cogmedia_proc(stories)

```

### Read real-time news in R!

You can read the news in R! Using `crayon`, we format news stories in your console so you can see real-time updates to the news. Simply set `cogmedia_data` parameter `peruse` to `TRUE`.

```R

stories = cogmedia_data(api_key='API_KEY', n_stories=20, peruse=TRUE)

```

Currently, the following three commands can be used at the prompt: describe X, goto X, q. X is the news story number as listed by `cogmedia_data` output.

### Installation

On occasion this version on GitHub will go out of alignment before we do a CRAN update. If this happens you can install from the repository this way:

```R

install.packages('devtools')

devtools::install_github('racdale/cogmedia-api')

```

