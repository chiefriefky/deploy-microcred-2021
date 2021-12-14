library(twitteR)
library(ROAuth)
library(syuzhet)
consumerKey = "nJ5pEXnjFA93t4dmv8DIKMN4m"
consumerSecret = "hzGF0znDrYEJn7l0pov0AEPa0xOiqnqlDVaRZqXWBAn55JK7Zk"
accessToken = "924719472-S7YzmK3EVHIo26RjBHKhfRChfayNnTvHcOfijqMK"
accessSecret = "kzVduImUgXKSJPHNvxCpH1mcM6jMchKzgj2ZJdWqrJMzW"

setup_twitter_oauth(consumerKey, consumerSecret, accessToken, accessSecret)
tweetsIndo = searchTwitter('PCR', since = '2021-11-07', until = '2021-11-12', lang = "id", n = 15000)
tweets.dfID <- twListToDF(tweetsIndo)
write.csv(tweets.dfID, file="D:/KULIAH/S2 STATISTIKA ITS/Semester 3/Microcredential Associate Data Scientist/Tugas/Kelompok/Final Project 1/PCR 7 November sampai 12 November.csv")
