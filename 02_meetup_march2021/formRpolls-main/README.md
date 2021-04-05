# formRpolls

How to create short polls with form{´r} and R notebooks on the fly?
Created by Annika Ziereis (If you have any questions, just contact me: annika.ziereis@web.de)

This is the general recipe (for the example, see below) : 


# 1. create survey and run in form{´r} https://formr.org/

- Check the very helpful documentation (https://formr.org/documentation) on how to do so.
- If you haven't done so before, create your free account.
- To create a survey you have to prepare your survey questions and items in a spread sheet. (e.g. in Excel or google sheets)
An example with many different item types can be viewed here: https://docs.google.com/spreadsheets/d/1vXJ8sbkh0p4pM5xNqOelRUmslcq2IHnY9o52RmQLKFw/edit#gid=1611481919 
Check out also some existing surveys for inspiration: https://formr.org/studies 


If you have created your survey and embedded it in a run, test it yourself. 
If everthing looks as if you want it to, you can prepare the analysis script :) 


# 2. Prepare the analysis script in R

(Install the packages you need for analyzing and vizualising your results.)
Importantly and to save time, you want to be able to connect with the form{´r} server to be able to download your survey results on the fly.
The easiest way to do so is by downloading the accompaning R-package "formr" from github. 
e.g. with the following code
require(devtools)
if (!require("formr")) devtools::install_github("rubenarslan/formr") 

Then you can connect with the server very easily: 
library(formr)
formr_connect(email = 'youremail@emailprovider.de', password = 'yourpassword', host = "https://formr.org")


# 3. Analyze and visualize your results (e.g. R markdown or R notebook) 

To get your results in the next step it is as easy as above:

results <- formr_raw_results(survey_name=surveyname, host = "https://formr.org") 
(maybe you want to get the items, too)
itemslist<-formr_items(survey_name = surveyname, 
                        host = "https://formr.org")
						
Now you have your results and can just work with it like with any other data you are used to work with (i.e. re-arranging, cleaning and plotting etc.)


Done :) 


## Example:
connectformR.R (put the credentials there to not having to type it in every time)
welcomemap.Rmd (R notebook: downloading and filtering survey results, and visualizing it, includes a simple multiple choice question and an (optionally interactive) worldmap, pie chart and bar charts with images)
feebackpolls.Rmd (R notebook: downloading and filtering data, and visualizing it, includes multiple choice questions with emojis (still as images though), images and open questions displayed as a list and wordcloud) 
mapR.R (function to create the world-map) 
the survey sheets for the two surveys:
formRpolls.xlsx (survey for the feedback)
littlepoll.xlsx (survey for welcomemap, including the map)

data from the ligthening talk to play with
dataformRpolls.csv
datalittlepoll.csv

