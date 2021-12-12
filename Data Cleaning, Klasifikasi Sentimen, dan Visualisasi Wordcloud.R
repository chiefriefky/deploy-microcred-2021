#library yang dibutuhkan 
library(tm)
datatweet <- read.csv("D:/KULIAH/S2 STATISTIKA ITS/Semester 3/Microcredential Associate Data Scientist/Tugas/Kelompok/Final Project 1/PCR 7 November sampai 12 November.csv")
View(datatweet)
#Proses pertama (Text Preprocessing)
PCR_Corpus <- Corpus(VectorSource(datatweet[,2]))
#1. menghilangkan URL (Uniform Resource Locator)
remove_URL <- function(x) gsub("http[^[:space:]]*", "", x)
PCR_cleaningdata_0 <- tm_map(PCR_Corpus, remove_URL)
inspect(head(PCR_cleaningdata_0))
#2. menghilangkan RT (Re-Tweet)
remove_RT <- function(y) gsub("RT", "", y)
PCR_cleaningdata_1 <- tm_map(PCR_cleaningdata_0, remove_RT)
inspect(head(PCR_cleaningdata_1))
#3. menghilangkan UN (User Name)
remove_UN <- function(z) gsub("@//w+", "", z)
PCR_cleaningdata_2 <- tm_map(PCR_cleaningdata_1, remove_UN)
inspect(head(PCR_cleaningdata_2))
#4. menghilangkan tanda baca
PCR_cleaningdata_3 <- tm_map(PCR_cleaningdata_2, removePunctuation)
inspect(head(PCR_cleaningdata_3))
#5. mengubah semua kata besar menjadi kata kecil
PCR_cleaningdata_4 <- tm_map(PCR_cleaningdata_3, tolower)
inspect(head(PCR_cleaningdata_4))
#6. menghilangkan angka
PCR_cleaningdata_5 <- tm_map(PCR_cleaningdata_4, removeNumbers)
inspect(head(PCR_cleaningdata_5))
#7. mengubah kata "/n/" menjadi spasi
PCR_cleaningdata_6 <- tm_map(PCR_cleaningdata_5, stripWhitespace)
inspect(head(PCR_cleaningdata_6))
#8. menghilangkan kata yang tidak penting (seperti we, they, i, me, etc)
PCR_cleaningdata_7 <- tm_map(PCR_cleaningdata_6, removeWords, 
                                  c("skrg", "kok", "ngga", "amp"))
inspect(head(PCR_cleaningdata_7))
#Proses kedua (Featuring Selection)
stopword = scan("D:/KULIAH/S2 STATISTIKA ITS/Semester 1/Konferensi dan Jurnal/Seminar Nasional Official Statistika STIS/Indonesia/stopwords.txt", what = "character", comment.char = ";")
#9. menghilangkan kata yang tidak penting (seperti daftar di dalam stopword)
PCR_cleaningdata_8 <- tm_map(PCR_cleaningdata_7, removeWords, stopword)
inspect(head(PCR_cleaningdata_8))
#menghitung frekuensi dari kata yang sering muncul dalam setiap dokumen
tdm = TermDocumentMatrix(PCR_cleaningdata_8)

#Remove sparse terms from a document-term or term-document matrix.
#menghapus kata-kata yang jarang atau bahkan tidak muncul sama sekali dari setiap dokumen
#{=removeSparseTerms(nama konstanta untuk membuat matriks frekuensi kata yang sering muncul dari setiap tweet ; peluang kata yang sering muncul dari setiap tweet)}
#menentukan peluang kata yang sering muncul dari setiap tweet berasal dari keinginan peneliti setelah melihat wordcloud
tdm1 = removeSparseTerms(tdm, 0.90)
tdm1

freq.terms <- findFreqTerms(tdm1, lowfreq = 10)
freq.terms

term.freq <- rowSums(as.matrix(tdm1))
term.freq <- subset(term.freq, term.freq >= 10)
df = data.frame(term = names(term.freq), freq = term.freq)
df

df_cleanedTweets <-  data.frame(text=get("content", PCR_cleaningdata_8), 
                                stringsAsFactors=T)
#setelah selesai cleaning data, bisa disimpan versi csv.
write.csv(df_cleanedTweets, file = "D:/KULIAH/S2 STATISTIKA ITS/Semester 3/Microcredential Associate Data Scientist/Tugas/Kelompok/Final Project 1/Cleaning Data PCR 7 November sampai 12 November.csv")


####-----------------------------------------------------------------------------####


###--------------------------------------------------------------------------------------###

pos.words = scan("D:/KULIAH/S2 STATISTIKA ITS/Semester 1/Konferensi dan Jurnal/Seminar Nasional Official Statistika STIS/Indonesia/positive.txt", what = "character", comment.char = ";")
neg.words = scan("D:/KULIAH/S2 STATISTIKA ITS/Semester 1/Konferensi dan Jurnal/Seminar Nasional Official Statistika STIS/Indonesia/negative.txt", what = "character", comment.char = ";")

## Convert the content of corpus into a dataframe
df_cleanedTweets = read.csv("D:/KULIAH/S2 STATISTIKA ITS/Semester 3/Microcredential Associate Data Scientist/Tugas/Kelompok/Final Project 1/Cleaning Data PCR 7 November sampai 12 November.csv")
list_cleanedTweets = as.list(df_cleanedTweets$text)

##Stringr package is needed to do string manipulations
library(stringr)
## Trim  extra white spaces
list_cleanedTweets = lapply(list_cleanedTweets,function(x) gsub(pattern = "//s+"," ",str_trim(x)))
## Split the sentence to separate words 
list_cleanedTweets = lapply(list_cleanedTweets,function(x) strsplit(x,split = " "))

## Convert the list to list of characters
unlist_CleanedTweets = sapply(list_cleanedTweets,unlist)

## give some meaningful name to variables
Kohlitweets = unlist_CleanedTweets

## let us try to get the positive scores
pos.scores = lapply(Kohlitweets,function(x){sum(!is.na(match(x,pos.words)))})
## let us try to get the negative scores
neg.scores = lapply(Kohlitweets,function(x){sum(!is.na(match(x,neg.words)))})
## let us try to get the net sentiment scores
net.scores = lapply(Kohlitweets,function(x){sum(!is.na(match(x,pos.words)))-sum(!is.na(match(x,neg.words)))})

## Lets unlist all the positive scores,negative scores and net scores
positive = unlist(pos.scores) ## This gives vector of integers
negative = unlist(neg.scores) ## This gives vector of integers
netSentiment = unlist(net.scores)## This gives vector of integers

## Let us name all tweets with postive , negative and Neutral
netSentiment[netSentiment>0]="Positive"
netSentiment[netSentiment<0]="Negative"
netSentiment = ifelse(netSentiment=="0","Neutral",netSentiment)
## Convert the net sentiment to factor variable
netSentiment = as.factor(netSentiment)
netSentiment
library(openxlsx)
write.xlsx(netSentiment, file = "D:/KULIAH/S2 STATISTIKA ITS/Semester 3/Microcredential Associate Data Scientist/Tugas/Kelompok/Final Project 1/Pos Neg Neutral PCR 7 November sampai 12 November.xlsx")

#memunculkan wordcloud
library(wordcloud)
tweets <- as.character(list_cleanedTweets)
wordcloud(tweets, random.order=T,min.freq= 300, colors=brewer.pal(8, "Dark2"))