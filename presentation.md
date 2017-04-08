# R Case Studies from a Software Engineer
###### by Charlie Chen ( [@Carolusian](https://github.com/carolusian) )
###### 21 Apr 2017 @ HKBU

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

# The 1st Case: Back Yourself for a New Feature

TODO: Picture

--- 

# Why Do I Learn R?

Why do I learn R when I already know other languages, e.g. Python?

* Python is syntactically simplier
* Python is more generic, and preferred among web and system developers
* Python has better performance
* Python has wider adoption, e.g. YouTube, DropBox, Quora, Pinterests, Disqus, Zhihu
* I am more familiar with python
* I spend more time in writing python code because of my job 
* Python has a google data science packages, like pandas, nltk, scikit-learn

---

# Why Do I Learn R?

* R directly does statistics 
* Direct access to resources: CRAN, R-Bloggers and Books
* R leads the way
* Integration with document publishing is superior, even compare with IPython notebook
* R packages are written by persons who are stronger in statistics

> **Pick the language best fits the need**
> I mainly use Python for `raw data processing` and R for statistical evaluations. Updating and adjusting the input data pretty easy in Python. The analytical work is can be performaned interactively with the standardized input dataset.

----

# The 2nd Case: How I Start to Learn R

##### Find something you can do in your life

---

# The 2nd Case: How I Start to Learn R

* We have a balance sheet for lunch and dinner payments
* Find what you can do with those data in that balance sheet
* I decide to draw a simply wordcloud with R
* Steps:
  * Take a look at the data structures in the balance sheet
  * Search online how to install R
  * Search what packages can be used to draw a wordcloud
  * Try it on your own data
  * Manually clean your data
  * Share the result with your colleagues

--- 

# The 3nd Case: Learn by Reading and Doing

* I purchased a book on Amazon with the most few pages as I am lazy
  * `Learn R in a Day`, by Steven Murray: http://amzn.to/2oF3H2K
  * Flip through it
  * Do a few of exercies on it to gain minimum viable skills to do projects
  * Do a real project, either replicate others or do your own, see http://bit.ly/2nHK0mb (`Map Visualisation for Panama Papers and Offshore Leaks in R`)

---

# Some Gists

* Get your hands dirty
* Divide and Conquer you problems