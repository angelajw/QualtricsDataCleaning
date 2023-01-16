#R Tutorial: Cleaning and filtering data from Qualtrics surveys, and creating new variables in the dataframe
#With step by step explanations
#By Angela Jiang-Wang
#R version used: 4.0.3 (2020-10-10) -- "Bunny-Wunnies Freak Out"
#Latest update: December 29th, 2021

#Hi all, many Qualtrics surveys used for experiments produce really similar output datasets
#I will share with you some of my preferred codes and their respective explanations for data cleaning and filtering, and also for creating new variables in the dataframe from existing data with functions and logical operators.
#As often happens with coding, there are many different ways of doing one same task in R. These are the codes I like using and that normally work for me.
#Hopefully this may help you so you don't get too crazy looking in forums and all over the internet like me for doing some simple stuff.

#Before starting, I'd like to tell you that you can make data cleaning much more efficient and easier with the right survey design in Qualtrics.
#For instance, you can edit how you want your variables to be named in the output dataset and how the values of each variable should be coded.
#Try playing with features such as Question names, Recode values, Question export tags (for questions with many items such as matrices) in order to produce a more "refined" dataset from Qualtrics.
#I will provide codes for an "unrefined" dataset, that is to say, for a case where the aforementioned features are not exploited. 
#Note that with a "refined" dataset, you will use really similar codes but just skipping some steps
#If you have any questions or comments, feel free to reach out to me in Twitter: @angyjiwa
#Your feedback is always welcome!

#Let's start!

#The first thing you'll wanna do is to set a working directory, so R will know which folder of your PC it should look into for functions such as importing files and saving new datasets
#A trick to set the WD fast is to go to the "Files" window in RStudio and click the file to be imported from your PC. Just copypaste what's written in "File/URL", but deleting the file name in the end
#This, for example, is my WD:

setwd("~/Desktop/uni/research/propio/GitHub codes/")

#Now you import the dataset. "d1" is just the name I assign to my new dataset, you can name it however you like

d1 <- read.csv("raw dataset.csv")

#You can also import datasets directly from GitHub. Here is the code, so you don't have to download the file :)

d1 <-read.csv("https://raw.githubusercontent.com/angelajw/QualtricsDataCleaning/main/raw%20dataset.csv")

#I like using the package tidyverse for cleaning data. To install, just write the command install.packages("tidyverse"). 

library(tidyverse)

#some codes to examine the dataframe. Best way to understand what they do is by trying them out!!

View(d1) #to view the dataframe in a separate window
head(d1) #to view the variables and the first rows of the dataframe
summary(d1)
str(d1) #to check out info of the variables

#another really helpful function to examine frequency of responses within variables is
table(d1$gender) #just write the name of the variable you want to check after d1$

#CLEANUP

#We create a second dataframe named d2 with only the variables we want. Note that while selecting variables, you can also rename them
#Unrefined Qualtrics datasets normally have very ugly variable names such as "Q3_1", so giving them names you'll understand is imperative
#Remember to examine the dataframe every few steps to see how you're advancing, with head() or View()
#use commas to select single variables, and use : to express "from x to y" (but then you cannot rename them)

d2  <- d1 %>% rename(consent1 = Q17, consent2 = Q20, consent3 = Q21,
           freediscount = Q16, paydiscount = Q22, fakeemail = Q18,
           likely1 = Q3_1, likely2 = Q3_2, likely3 = Q3_3, likely4 = Q3_4,
           annoyed1 = Q24_1, annoyed2 = Q24_2, annoyed3 = Q24_3,
           annoyed4 = Q24_4, control = Q5, reasonable1 = Q6_1,
           reasonable2 = Q6_2, reasonable3 = Q6_3, reasonable4 = Q6_4,
           reasonable5 = Q6_5, reasonable6 = Q6_6, reasonable7 = Q6_7,
           reasonable8 = Q6_8, reasonable9 = Q6_9, comfortable1 = Q7_1,
           comfortable2 = Q7_2, comfortable3 = Q7_3, comfortable4 = Q7_4,
           comfortable5 = Q7_5, comfortable6 = Q7_6, comfortable7 = Q7_7,
           comfortable8 = Q7_8, comfortable9 = Q7_9, ac = Q19,
           comfortable10 = Q8, comments = Q24)

# Convert column names to lower to avoid mismatching on case sensitivity
names(d2)  <- tolower(names(d2))

# Verify desired column name changes
d2 %>% select(contains(c('consent','discount','fake','likely','annoyed','contol','reason','comfortable','ac','gender','age','condition')))

# Retain only desired columns
d2 <- d2 %>% select(contains(c('consent','discount','fake','likely','annoyed','contol','reason','comfortable','ac','gender','age','condition')))

# Check for NA's
any(is.na(d2)) #to check if there are missing values (in this case we have NAs)

colSums(is.na(d2)) #to check which variables contain missing values and how many of them

# If we had missing values - and wanted to do further exporation, we could;

# Create an example df - na_df to show examples
x<-rep(c(NA,2,5,10,15),times=4) # Assign values to x column for na_df
y<-rep(c(NA,rnorm(1),rnorm(1),rnorm(1)),times=5) # Assign values to y column for na_df
na_df <- data.frame(x,y) # Combine to na_df for example

head(na_df,20) # view the output

colSums(is.na(na_df)) # Get total NA values per column
cbind(colSums(is.na(na_df))) # In a long format for readability (helpful in this format if there are a lot of columns)
data.frame(result = colSums(is.na(na_df))) %>% # Get na values per col name with NA count in descending order (helpful when there are a lot of columns)
       arrange(desc(result))

#Now we delete the first two rows. Normally you always do this step with Qualtrics datasets
#A useful thing to know is that within d2[ , ], the part before the comma corresponds to rows, and the part after the comma corresponds to columns.
#You write the row or column numbers you are selecting or, in this case, unselecting for the new dataset (by assigning a minus sign before the numbers)
#The function c() is for combining many values together

d2 <-d2[-c(1:2) , ]

#If you have downloaded the dataframe using choice text, you'll need to recode the values to the numbers you want

#use this code for recoding a single variable
#Don't worry about the warning message that appears: it just means that any value outside from the ones specified in the code will be treated as NA

d2$fakeemail <- recode(d2$fakeemail, "Not at all likely1" = 1,
                       "2" = 2, "3" = 3, "4" = 4, "5" = 5, "6" = 6,
                       "Very likely7" = 7)

d2$control <- recode(d2$control, "No control at all\n1" = 1,
                     "2" = 2, "3" = 3, "4" = 4, "5" = 5,
                     "6" = 6, "Very much control\n7" = 7)

#and you can use this code to recode many columns at once
#d2[,c(7:10)] means you are applying the changes to columns 7 to 10 from d2
               
d2[,c(7:10)] <- lapply(d2[,c(7:10)], function(x) 
                 recode(x,"Not at all likely\n1" = 1, "2" = 2,
                        "3" = 3, "4" = 4, "5" = 5, "6" = 6,
                        "Very likely\n7" = 7))     

#to find the number of a column through its name, you may use this code
which( colnames(d2)=="likely1" ) #write the name of the variable and it will return the column number


d2[,c(11:14)] <- lapply(d2[,c(11:14)], function(x) 
                 recode(x,"Not at all annoyed\n1" = 1, "2" = 2,
                        "3" = 3, "4" = 4, "5" = 5, "6" = 6,
                        "Very annoyed\n7" = 7))
                 

d2[,c(16:24)] <- lapply(d2[,c(16:24)], function(x) 
                 recode(x,"Not at all reasonable1" = 1,
                        "2" = 2, "3" = 3, "4" = 4, "5" = 5,
                        "6" = 6, "Very reasonable7" = 7))
                 
d2[,c(25:33, 35)] <- lapply(d2[,c(25:33, 35)], function(x) 
                 recode(x,"Not  at all comfortable\n1" = 1,
                        "2" = 2, "3" = 3, "4" = 4, "5" = 5,
                        "6" = 6, "Very comfortable\n7" = 7))

sapply(d2, class) #examine whether variables are numeric or character
#If you notice anything going wrong during this step, always double check that the original text is written correctly. Sometimes, just an extra space changes everything!
#For example, "Not  at all comfortable\n1" has an extra space between "Not" and "at". It is always these tiny things that create errors!
#If you are unsure, remember to use table(d2$comfortable1) both before and after recoding values  

#convert variables from character to numeric. 
#Note that if you directly use the function as.numeric without using as.character first, numbers can become messed up

d2$freediscount <- as.numeric(as.character(d2$freediscount))

d2$paydiscount <- as.numeric(as.character(d2$paydiscount))

d2$age <- as.numeric(as.character(d2$age))

#if you want to convert many variables to numeric at once, you may try this as well

d3 <- select(d2, freediscount:paydiscount, age) #create a new dataset with the columns you want to convert, use : to specify "from column x to column y"
d3 <- lapply(d3, function(x) as.numeric(as.character(x)))
d3=data.frame(d3)
names(d3)=paste(names(d3),"n",sep = "") #rename the variables by adding an n to their name to differentiate them
d4=cbind(d3,d2) #merge the 2 datasets into a new d4

#Alternatively, if you want to convert all variables to numeric, just do this

d5 <- lapply(d2, function(x) as.numeric(as.character(x)))
d5=data.frame(d5) #be careful: all variables that had text now are treated as NAs (e.g., consent1, gender)
#Only do this if all your variables have numbers, or you don't care about the other variables

#this is yet another different way of transforming many variables at once
#(however I don't find this approach much more efficient than going one by one)

d2 <- transform(
  d2,
  freediscount=as.numeric(as.character(freediscount)),
  paydiscount=as.numeric(as.character(paydiscount)),
  age = as.numeric(as.character(age))
)


#we will continue with d2 

#FILTER 

#create a new dataframe only with participants that responded "yes" to the 3 consent questions
#you may use many different logical operators for filtering data
#most common ones are "&" to express AND and "|" to express OR
#you can also use != to express "not equal to"

d3<-d2[which(d2$consent1 == "Yes" & d2$consent2 == "Yes" &
               d2$consent3 == "Yes"), ]

#Subset d3 only with participants that answered "Somewhat flexible" to the attention check question

d3<- d3[which(d3$ac == "Somewhat flexible"), ]

#CREATING NEW VARIABLES

#Create variables which are the averages of other variables
#In this case, we are creating new variables called "likely" and "annoyed"

d3=within(d3,
          { likely = rowMeans( cbind(likely1,likely2,
                    likely3, likely4), na.rm = T)
          annoyed = rowMeans( cbind(annoyed1, annoyed2,
          annoyed3, annoyed4), na.rm = T)})

#use the argument na.rm=T to omit NAs
#Note that it is the same as writing

d3$likelyy = (d3$likely1 + d3$likely2 + d3$likely3 + d3$likely4)/4 
#naming this likelyy to differentiate it from the previously created likely variable
#This latest code may be more intuitive, but the previous code is faster! (you can also create many new variables at once)
#you can easily check that the variables likely and likelyy are identical

#Create variables by summing them
#Now we call our new variables "likelysum" and "annoyedsum"

d3=within(d3,
          { likelysum = rowSums( cbind(likely1,likely2,
                                     likely3, likely4), na.rm = T)
          annoyedsum = rowSums( cbind(annoyed1, annoyed2,
                                    annoyed3, annoyed4), na.rm = T)})

#similarly, you can do the same thing by writing this
d3$likelysumm = d3$likely1 + d3$likely2 + d3$likely3 + d3$likely4

#likelysum and likelysumm are identical variables

#In this survey, participants would either see the question "freediscount" or "paydiscount", but never both at once (different treatments)
#So whenever participants answer the question "freediscount", there is a missing variable in "paydiscount", and viceversa
#Let's merge the variables freediscount and paydiscount into a single one

d3[is.na(d3)] <- 0 #we convert all missing values into 0

d3$discount <- d3$freediscount + d3$paydiscount #we create this new variable named "discount", which is the sum of the other two
#you can also use the function rowSums() for this

#Note: the approach above only works because in this survey, blank responses were not allowed
#if that is not the case and there may be "real" missing values in your data, another solution should be found, or "real" NAs should be taken care of before this step
#remember that with the correct survey design, you may make your life easier directly from Qualtrics

#Create variables by setting conditions

#let's create a column called female
#If gender = female, then the new variable will have a 1. Otherwise it will be 0

d3$female = NULL
d3$female [d3$gender == "Female"] = 1
d3$female [d3$gender != "Female" ] = 0

#Alternatively, you may also use a function to do this
#You are expressing that if gender = female, female2 should have a 1, and 0 otherwise

d3$female2 = ifelse (d3$gender == "Female",1, 0)

#you can check that the variables female and female2 are identical :)
#the last function is very useful because you can combine it with other functions
#see this example:

d3=within(d3,
          { discount2 = ifelse (d3$discount=="0",NA,
          rowSums(cbind(freediscount, paydiscount), na.rm = T))})

#here we are setting that if "discount" = 0, discount2 should be treated as NA, otherwise it should be the sum of freediscount and paydiscount

#OTHER USEFUL FUNCTIONS

#clear workspace

rm(list = ls())

#get % females

nrow(d3[which(d3$gender == "Female"),])/nrow(d3)*100


#SAVE THE NEW DATASET

#If you haven't set a WD yet, now it is the time to do it!

write.csv(d3, "clean data.csv")


