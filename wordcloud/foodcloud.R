library(showtext)
# quartz(
#  family="STKaiti")
png(file = "myplot.png", bg = "transparent",  width=12,height=8, units='in', res=1000)
showtext.begin()

balance <- read.csv("balance.csv", FALSE) 
balance["T"] <- rep.int(1, 461)
wordfreq = aggregate(T ~ V2, balance, sum)

library(wordcloud)
library(RColorBrewer)
wordcloud(words=wordfreq$V2, freq=wordfreq$T, min.freq = 1, max.words=100, random.order=FALSE, scale=c(5,0.5),rot.per=0.35,colors=brewer.pal(8, "Dark2"))
dev.off()


