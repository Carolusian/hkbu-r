library(tm)
library(dplyr)
library(stringr)
library(stringdist)
df_addr <- read.csv('offshore_leaks_csvs/Addresses.csv')
df_area <- read.csv('city_province_mapping.csv', header=FALSE)
provinces <- unique(df_area$V2)
cities <- unique(df_area$V1)

df_addr <- df_addr[df_addr$country_codes %in% c('CHN'), ]
print(nrow(df_addr))
df_addr$loweraddr <- tolower(df_addr$address)
addresses <- df_addr$loweraddr
corpus <- Corpus(VectorSource(addresses))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, stripWhitespace)
addresses <- sapply(corpus, as.character)

# Split addresses into vector of strings, e.g. c("Chaoyang", "District", "beijing")
addrwords <- sapply(addresses, function(x)strsplit(x, " "))

# Avoid things like "beijing road" being included, 
# city or province always appears in the tail of addresses
addr_city <- sapply(addrwords, function(w)tail(intersect(w, cities), n=1))
addr_province <- sapply(addrwords, function(w)tail(intersect(w, provinces), n=1))

# intersect returns a list, but we want a string
df_addr$city <- sapply(addr_city, function(city) if(paste(city, "", sep="") == "character(0)") return("") else return(paste(city,"", sep="")))
df_addr$province <- sapply(addr_province, function(province) if(paste(province, "", sep="") == "character(0)") return("") else return(paste(province, "", sep="")))


# The above steps only found "shandong", 
# We use fuzzy match to find "shan dong"
fuzzy_province <- function(addrwords, provinces, dist = 0) {
  for(province in provinces) {
    mtr <- stringdistmatrix(addrwords, province)
    for(i in (seq_along(mtr[,1]))) {
      if(i<length(mtr[,1])) {
        # The matrix distance should be equal or shorter than string length of province
        if (mtr[,1][i] + mtr[,1][i+1] <= str_length(province) + dist) {
          if(startsWith(province, addrwords[i]) & abs(str_length(province) - str_length(addrwords[i]) - str_length(addrwords[i+1])) <= dist ) {
            return(province)
          }
        }
      }
    }
  }
  return("")
}

# Similar to fuzzy.province, but match in a more strict way
fuzzy_city<- function(addrwords, cities) {
  for(city in cities) {
    mtr <- stringdistmatrix(addrwords, city)
    for(i in (seq_along(mtr[,1]))) {
      if(i<length(mtr[,1])) {
        if (mtr[,1][i] + mtr[,1][i+1] <= str_length(city)) {
          if(paste(addrwords[i], addrwords[i+1], sep="") == city){
            return(city)
          }
        }
      }
    }
  }
  return("")
}

attach(df_addr)
# Find province, city info for addresses that not found in previous steps
df_other <- df_addr[sapply(city, str_length)==0 & sapply(province, str_length)==0, ]
other <- df_other$loweraddr
corpus <- Corpus(VectorSource(other))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, stripWhitespace)
addresses <- sapply(corpus, as.character)
addrwords <- sapply(addresses, function(x)strsplit(x, " "))
addr_province <- sapply(addrwords, function(w)fuzzy_province(w, provinces, dist=1))
addr_city<- sapply(addrwords, function(w)fuzzy_city(w, cities))
df_other$province <- paste(addr_province, "", sep="")
df_other$city <- paste(addr_city, "", sep="")
detach(df_addr)

df_addr <- rbind(df_addr[!df_addr$node_id %in% df_other$node_id,], df_other)
df_addr$row <- strtoi(row.names(df_addr))
df_addr <- df_addr[order(df_addr$row),]
write.csv(df_addr, "addresses_cn.csv")

# If certain df_addr only has city rather than province, need to map city to province
library(stringr)
df_addr <- read.csv("addresses_cn.csv")
df_city_only_addr <- df_addr[sapply(df_addr$city, str_length)>0 & sapply(df_addr$province, str_length)==0,]
df_province <- read.csv("city_province_mapping.csv", header=F)
colnames(df_province) <- c("city", "provinces")
# Duplicate city cause the increase of 100 rows. approximately 2% of the totaly number of rows
df_city_addr <- merge(df_city_only_addr, df_province, by = "city")
df_city_addr$province <- df_city_addr$provinces
df_city_addr <- df_city_addr[, colnames(df_addr)]
df_addr <- rbind(df_addr[!df_addr$node_id %in% df_city_addr$node_id,], df_city_addr)
df_addr <- df_addr[order(df_addr$row),]
write.csv(df_addr, "addresses_cn_final.csv")
