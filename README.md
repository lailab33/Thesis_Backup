# Thesis_Backup
This is a backup for my senior captstone project at Vassar College for the completion of my cognitive science major. I track the usage of the term "Environmental Validity" in articles indexed by Scopus in an attemtpt to understand how the concerns about replication, generalization, and 

My project will be available at my college's online digital library after the summer of 2022.


Repository organization
-
### Folders
Thesis_Figures/figure-html: Are the 

thesis_abstract_wordcloud: This is a wordcloud shiny app to see the changes in words used in the abstracts by years. It should be downloaded and used along with `data.split.csv`.

`thesis_bar_items`: This is a shiny app which tracks what kinds of items (articles, conferences, erratum, etc) were published by year about ecological validity. It should be downloaded and used along with `data.csv`.

`thesis_histogram`: This is a shiny app which can cound the number of citations that different articles about EV have obtained through the years. It should be downloaded and used along with `data.csv`.

`thesis_keyword_wordcloud`: This is a wordcloud shiny app to see the changes in words used in the keywords by years. It should be downloaded and used along with `data.split.csv`.

`thesis_title_wordcloud`: This is a wordcloud shiny app to see the changes in words used in the titles by years. It should be downloaded and used along with `data.split.csv`

### Files
`Thesis_script.Rmd`: This is the main code of the project, which can be downloaded and opened with R Studio. 

`Thesis_script.nb.html`: This is an HTML version of the project, which can be downloaded and viewed in any browser.

`articles.by.year.csv`: This is a data frame that contains the number of psychology articles indexed by Scopus from 1940 to 2021, as seen by be on February 14th 2022.

`data.location.none.csv`: This is a file that has corrected information about where the keywords are found in the article. It is meant to be used with the project script.

`ev_1.csv`/`ev_2.csv`/`ev_3.csv`: This is the indexing data that I downloaded from Scopus which contained "ecological validty" or "ecologically valid" in the title, abstract, or keywords on February 14th 2022.

`scopus_journal_counts.csv`: This is the indexing data frame from the Scopus representative to Vassar College, which contains all of the conferences and journal titles with the number of articles that Scopus has indexed from them by year since 1942. Downloaded Jan-Feb 2022.

`scopus_source_list.csv`: This is the indexing data frame from the Scopus representative to Vassar College, which has all of the conferences and journal titles with the total number of articles that Scopus has indexed from them. Downloaded Jan-Feb 2022.

`thelwall.all.abstracts.csv`: This is the information obtained from Thelwall and Pardeep's "Scopus 1900–2020: Growth in articles, abstracts, countries, fields, and journals" about the shape of Scopus' indexing database. The article available open access at https://direct.mit.edu/qss/article/doi/10.1162/qss_a_00177/109076/Scopus-1900-2020-Growth-in-articles-abstracts and this information was downloaded from the supplementary material at: https://figshare.com/articles/dataset/Scopus_1900-2020_Growth_in_articles_abstracts_countries_fields_and_journals/16834198. 
