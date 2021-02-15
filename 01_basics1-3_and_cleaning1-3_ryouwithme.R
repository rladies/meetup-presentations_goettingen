
#packages (Basics 2)---- 
#install in console first if necessary (install.packages("name))
library(tidyverse)
library(here)
library(janitor)
library(skimr)
library(praise) #just for fun


#read in and explore data (Basics 3)----

#check where "here"-package thinks our data is
here()
#we can refer to datafiles relative to this location!

#create new object "beaches" (dataframe) from csv-file
beaches <- read_csv(here("data","sydneybeaches.csv"))

#well done
praise()

#explore data

#look at spreadsheet
View(beaches)

#dimensions (rows and columns)
dim(beaches)

#structure: variable names and types
str(beaches)

#prettier alternative to str:
glimpse(beaches)

#see first six rows
head(beaches)

#see last six rows
tail(beaches)

#summary of each variable
summary(beaches)

#explore data with a function from skimr package (load if needed)
skim(beaches)

#well done
praise()


#cleaning up column names (Clean it up 1)----

#in r, you need to type variable names often - so it's important to name them sensibly

#select all columns in dataframe, and make them all uppercase:
select_all(beaches,toupper)
#tip: press tab key in function with empty brackets to see what input is expected

#all to lowercase
select_all(beaches,tolower)

#clean names from janitor: all to lower and underscores
clean_names(beaches)

#see only names of variables
names(beaches)

#names are unchanged because we haven't yet changed our dataframe with the output of these functions

#make new dataframe from old dataframe with clean names
cleanbeaches <- clean_names(beaches)

#another possibility would be to overwrite the old dataframe: beaches <- clean_names(beaches)

#see names of new dataframe
names(cleanbeaches)

#rename enterococci column to something easier
#input: data, newname = oldname
rename(cleanbeaches, beachbugs = enterococci_cfu_100ml)

#see names 
names(cleanbeaches)

#overwrite to permanently change name
cleanbeaches <- rename(cleanbeaches, beachbugs = enterococci_cfu_100ml)

#see names 
names(cleanbeaches)

#save clean data to folder
write_csv(cleanbeaches,"cleanbeaches.csv")
#this by default saves to "Ryouwithme"-folder, but can be put in subfolder "data" via drag and drop

praise()

#exploring the data (Clean it up 2)----

#which beach is the dirtiest (most bugs)?

#arrange (= sort by) using the pipe-operator (magrittr-package, loads with tidyverse)
cleanbeaches%>%
  arrange(beachbugs)

#arrange in the same way without pipe
arrange(cleanbeaches,beachbugs)

#sort in descending order instead (with and without pipe)
cleanbeaches%>%
  arrange(-beachbugs)

arrange(cleanbeaches,-beachbugs)

#save arranged data to new dataframe "worstbugs"
#allows better look at data, e.g. the full date of worst measurement
worstbugs <- cleanbeaches %>% arrange(-beachbugs)

#combine filter and arrange function to find worst value in a specific subset of the data
#now pipe is very handy because it allows to put ("pipe") the data through several steps with just one command
#you can read each pipe symbol as an "and then..."

#Read code below as:
#"take cleanbeaches data, 
  #and then filter for Coogee beach (only keep Coogee Beach data),
  #and then arrange this subset by bugs in descending order (to find worst measurement at Coogee  beach)"

cleanbeaches%>%
  filter(site=="Coogee Beach")%>%
  arrange(-beachbugs)

#worst day in Coogee Beach is much better than the worst measurement overall

#make new dataframe to be able to see the full date
worstcoogee <-
cleanbeaches%>%
  filter(site=="Coogee Beach")%>%
  arrange(-beachbugs)

#comparing maximum bug values across different beaches

#looking at just Coogee Beach and Bondi Beach in new dataset. Which is dirtier?

coogee_bondi <-
cleanbeaches%>%
  filter(site %in% c("Coogee Beach","Bondi Beach")) #filters for either Coogee or Bondi

#another possibility: using the logical "or" operator | (windows: press AltGr+<)
coogee_bondi <-
cleanbeaches%>%
  filter(site == "Coogee Beach" | site == "Bondi Beach")
  
#the first option (like in the video) should be easier the more criteria you have

#continue in first pipe, arrange by beachbugs
coogee_bondi <-
  cleanbeaches%>%
  filter(site %in% c("Coogee Beach","Bondi Beach"))%>%
  arrange(-beachbugs)

#get summary statistics by group
cleanbeaches%>%
  filter(site %in% c("Coogee Beach","Bondi Beach"))%>%
  group_by(site)%>% #group by site - otherwise we would get the stats across sites (beaches)
  summarise(maxbugs = max(beachbugs, na.rm=TRUE), #remove missing values for calculation
            meanbugs = mean(beachbugs, na.rm=TRUE),
            medianbugs = median(beachbugs, na.rm=TRUE),
            sdbugs = sd(beachbugs, na.rm=TRUE))

#get summary statistics for all beaches by removing filter, sort by median in descending order (not in video)
cleanbeaches%>%
  group_by(site)%>% #group by site - otherwise we would get the stats across sites (beaches)
  summarise(maxbugs = max(beachbugs, na.rm=TRUE), #remove missing values for calculation
            meanbugs = mean(beachbugs, na.rm=TRUE),
            medianbugs = median(beachbugs, na.rm=TRUE),
            sdbugs = sd(beachbugs, na.rm=TRUE))%>%
  arrange(-medianbugs) # from here, the pipe operates on the summary statistics 
  
#get summary statistics by council

#how many distinct councils are in the data?
cleanbeaches %>%
  distinct(council)

#means and medians by council (across beaches)
cleanbeaches%>%
  group_by(council)%>% 
  summarise(meanbugs = mean(beachbugs, na.rm=TRUE),
            medianbugs = median(beachbugs, na.rm=TRUE))

#means and medians by council and site
cleanbeaches%>%
  group_by(council,site)%>% 
  summarise(meanbugs = mean(beachbugs, na.rm=TRUE),
            medianbugs = median(beachbugs, na.rm=TRUE))

#save summary stats to object
councilbysite <-
cleanbeaches%>%
  group_by(council,site)%>% 
  summarise(meanbugs = mean(beachbugs, na.rm=TRUE),
            medianbugs = median(beachbugs, na.rm=TRUE))

#see object
councilbysite

#making new variables (Clean it up 3)----

glimpse(cleanbeaches)

#separate date-column into day, month, year 
testdate <-
cleanbeaches%>%
  separate(date,c("day","month","year"),remove=FALSE) #separate date column, keep original as well

#new column with concil and site combined
cleanbeaches%>%
  unite(council_site,council:site,remove=FALSE)

#log-transform beachbugs-column
cleanbeaches%>%
  mutate(log_beachbugs = log(beachbugs))

#compute new numeric variable: difference between each value and the value of the previous row (lag)
cleanbeaches%>%
  mutate(diff_beachbugs = beachbugs - lag(beachbugs))

#compute a logical variable (output: TRUE/FALSE)
#indicate whether each value is higher than the average
cleanbeaches%>%
  mutate(buggier = beachbugs > mean(beachbugs,na.rm=TRUE)) #remove NAs

#to check
mean(cleanbeaches$beachbugs,na.rm=TRUE)

#pipe it all together (except uniting council and site)
cleanbeaches_new <- cleanbeaches%>%
  separate(date,c("day","month","year"),remove=FALSE)%>%
  mutate(log_beachbugs = log(beachbugs))%>%
  mutate(diff_beachbugs = beachbugs - lag(beachbugs))%>%
  mutate(buggier = beachbugs > mean(beachbugs,na.rm=TRUE))%>%
  group_by(site)%>%
  mutate(buggier_site = beachbugs > mean(beachbugs,na.rm=TRUE)) #is value bigger than average OF ITS SITE?
  
  


