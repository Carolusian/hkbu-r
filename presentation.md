# R Case Studies from a Software Engineer
###### by Charlie Chen ( [@Carolusian](https://github.com/carolusian) )

---

# The 1st Case: Back Yourself for a New Feature

* Background
  * Increased AWS CloudFront CDN costs
  * Increased loading time of the main site

---

# The 1st Case: Back Yourself for a New Feature

* What to do?
  * Make a guess
  * Verify your guess using R

---

# The 1st Case: Back Yourself for a New Feature

```bash
aws s3 ls s3://{{bucket_name}} > {{yyyymm.txt}}
cat {{yyyymm.txt}} | awk '{ print $3}'
```

```r
df <- read.csv('{{yyyymm.csv}}', header=F) / 1024
colnames(df) <- c('size')
df <- df[df$size < 1000, ]

breaks <- seq(from=0, to=1001, by=100)
h <- hist(df, breaks, plot=F)
h$density <- h$counts / sum(h$counts) * 100
plot(h, freq=F, main='Image Size Distribution 2017.03', xlab='Size in KB', ylab='Percent %')
```

---

# The 1st Case: Back Yourself for a New Feature
```r
files <- list.files()
files <- files[grepl('20.*csv', files) == T]

for(f in files) {
  assign(f, read.csv(f, header=F))
}

par(mfrow = c(length(files), 1))
breaks <- seq(from=0, to=1001, by=100)
for(f in files) {
  df <- get(f) / 1024
  colnames(df) <- 'size'
  df <- df[df$size < 1000, ]
  h <- hist(df, breaks, plot=F)
  h$density <- h$counts / sum(h$counts) * 100
  plot(h, freq=F, main=paste('Image Size Distribution', f), xlab='Size in KB', ylab='Percent %')
}
```
