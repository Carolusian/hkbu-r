sizes <- read.table('feb.csv', header=F)[3] / 1024
sizes <- sizes[sizes < 1000]
bins <- seq(from=0, to=1001 , by=100) 
h <- hist(sizes, bins)



































































h <- hist(sizes, breaks=bins, plot=F)
h$density <- h$count / sum(h$count) * 100
plot(h, freq=F, main)
