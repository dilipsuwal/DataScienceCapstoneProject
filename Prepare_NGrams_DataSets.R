### Setting environemt
setwd("C:/WorkSpace/DataScience/10.DataScienceCapstone/Dataset/en_US")
Sys.setenv(JAVA_HOME="C:/Program Files/Java/jre1.8.0_151/")

library(RWeka)
library(stringi)
library(tm)
library(ggplot2)
library(data.table)
library(SnowballC)

### Loading Data
blogs <- readLines("en_US.blogs.txt", encoding = "UTF-8", skipNul = TRUE)
news <- readLines("en_US.news.txt", encoding = "UTF-8", skipNul = TRUE)
twitter <- readLines("en_US.twitter.txt", encoding = "UTF-8", skipNul = TRUE)

### Clean and Sample Data

## Remove non-ASCII
blogs <- iconv(blogs, "latin1", "ASCII", sub="")
news <- iconv(news, "latin1", "ASCII", sub="")
twitter <- iconv(twitter, "latin1", "ASCII", sub="")

#Sampling Data
set.seed(1)
sample_data <- c(sample(blogs, length(blogs) * 0.03),
                 sample(news, length(news) * 0.03),
                 sample(twitter, length(twitter) * 0.03))


# Build corpus
corpus <- VCorpus(VectorSource(sample_data))
# Convert to lowercase
corpus <- tm_map(corpus, tolower)
# Remove punctuation
corpus <- tm_map(corpus, removePunctuation)
# Remove numbers
corpus <- tm_map(corpus, removeNumbers)
# Remove unneccesary white spaces
corpus <- tm_map(corpus, stripWhitespace)
# Plain text
corpus <- tm_map(corpus, PlainTextDocument)


### Tokenize and Calculate Frequencies of N-Grams

#Tokenize for uniqrams, bigrams, and trigrams.
uni_tokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 1, max = 1))
bi_tokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
tri_tokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))
tetra_tokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 4, max = 4))

#Build Term Document matrices of uniqrams, bigrams, and trigrams.
uni_matrix <- TermDocumentMatrix(corpus, control = list(tokenize = uni_tokenizer))
bi_matrix <- TermDocumentMatrix(corpus, control = list(tokenize = bi_tokenizer))
tri_matrix <- TermDocumentMatrix(corpus, control = list(tokenize = tri_tokenizer))
tetra_matrix <- TermDocumentMatrix(corpus, control = list(tokenize = tetra_tokenizer))

#Calculate frequency of n-grams
uni_corpus <- findFreqTerms(uni_matrix,lowfreq = 50)
bi_corpus <- findFreqTerms(bi_matrix,lowfreq=50)
tri_corpus <- findFreqTerms(tri_matrix,lowfreq=50)
tetra_corpus <- findFreqTerms(tetra_matrix,lowfreq=50)


uni_corpus_freq <- sort(rowSums(as.matrix(uni_matrix[uni_corpus,])), decreasing = TRUE)
uni_corpus_freq <- data.table(word=names(uni_corpus_freq), frequency=uni_corpus_freq)
bi_corpus_freq <- sort(rowSums(as.matrix(bi_matrix[bi_corpus,])), decreasing = TRUE)
bi_corpus_freq <- data.table(word=names(bi_corpus_freq), frequency=bi_corpus_freq)
tri_corpus_freq <- sort(rowSums(as.matrix(tri_matrix[tri_corpus,])), decreasing = TRUE)
tri_corpus_freq <- data.table(word=names(tri_corpus_freq), frequency=tri_corpus_freq)
tetra_corpus_freq <- sort(rowSums(as.matrix(tetra_matrix[tetra_corpus,])), decreasing = TRUE)
tetra_corpus_freq <- data.table(word=names(tetra_corpus_freq), frequency=tetra_corpus_freq)

setwd("C:/WorkSpace/DataScience/10.DataScienceCapstone/Dataset/en_US")
save(uni_corpus_freq, file = "uni_word.RData")
save(bi_corpus_freq , file = "bi_words.RData")
save(tri_corpus_freq , file = "tri_words.RData")
save(tetra_corpus_freq , file = "tetra_words.RData")

