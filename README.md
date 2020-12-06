# Useful R codes for cleaning and filtering data from Qualtrics surveys, and for creating new variables in the dataframe

By Ángela Jiang-Wang

#R version used: 4.0.3 (2020-10-10) -- "Bunny-Wunnies Freak Out"

Hi all, many Qualtrics surveys used for experiments produce really similar output datasets.

I will share with you some of my preferred codes for data cleaning and filtering, and also for creating new variables in the dataframe from existing data

As often happens with coding, there are many different ways of doing one same task in R. These are the codes I like using and that normally work for me.

Hopefully this may help you so you don't get too crazy looking in forums and all over the internet like me for doing some simple stuff.

Before starting, I'd like to tell you that you can make data cleaning much more efficient and easier with the right survey design in Qualtrics.
For instance, you can edit how you want your variables to be named in the output dataset and how the values of each variable should be coded.
Try playing with features such as Question names, Recode values, Question export tags (for questions with many items such as matrices) in order to produce a more "refined" dataset from Qualtrics.

I will provide codes with step-by-step explanations for "unrefined" datasets, that is to say, for cases where the aforementioned features are not exploited. 
Note that with a "refined" dataset, you will use really similar codes but just skipping some steps.


If you have any questions or comments, feel free to email me at: angelajw11@gmail.com
