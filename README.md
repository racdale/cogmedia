# CogMedia API

CogMedia's core data is available for download in throttled buckets. In order to obtain a free API key, please email rdale@ucla.edu. 

With the API, you can summon data right inside R, in the following way:

```R

stories = cogmedia(source='all',date='2019-03-10');
stories = cogmedia(source=c('la times','ny times','fox news'),date='2019-03-10');

```
