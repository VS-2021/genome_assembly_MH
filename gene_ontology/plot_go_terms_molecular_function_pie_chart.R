# set working directory
setwd("/Users/matthewwilliamhaas/Documents/wild_rice/annotation_figures")

# load required pacakges
library(data.table)

# get the modified pie function (to allow for GO terms to print at different angles)
source("modified_pie_function.R")

# read in data
x <- fread("go_molecular_function_genes.csv")

# change column names
x <- setnames(x, c("gene", "annotation", 'GO_term'))

# replace extraneous characters from GO_terms column
x <- x[, GO_term := sub("F:", "", GO_term)]
x <- x[, GO_term := sub(";", "", GO_term)]

# count and order the number of GO terms
y <- x[, .N, by="GO_term"]
y <- y[order(-N)]

# define top 13 GO terms
top13_go_terms <- y[c(1:13)]$GO_term

# label the top 13 GO terms with the GO ID number
y[GO_term %in% top13_go_terms, label := GO_term]

# how many GO terms are there with the "other" label? (1890)
sum(y[c(14:nrow(y))]$N)

# put all of the low-occurence GO terms into a single row with the label "other"
z <- y[c(1:13)]
new_row <- data.table(GO_term = "other", N = 7741, label="other")
z <- rbind(z, new_row)

# set the angle for GO terms to print so that they're easier to read
# set most to 45 degrees as a default
z[, srt := 310]
# then specify which ones could be set to 0 degrees (completely horizontal)
z[GO_term %in% c("GO:0003677", "GO:0004674", "GO:0005524", "GO:0004672", "other"), srt := 0]

# make pie chart and save to file
png("go_terms_molecular_function.png")
pie(z$N, labels=z$label, main="Molecular Function", cex=1, srt=z$srt)
dev.off()

