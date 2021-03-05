require( "psych")
require("ggplot2")

tweet_data = read.csv(file.choose())  # Read in .csv file for twitter data
tweet_data$Date = as.Date(tweet_data$Date, format = "%m/%d/%Y") # Transform numerical dates into type "Date"
tweet_data = unique(tweet_data)  # Remove duplicate rows
tweet_data$numeric_date = as.numeric(tweet_data$Date)
describe(tweet_data$Sentiment)
describe(tweet_data$Subjectivity)
cor(tweet_data$Sentiment,tweet_data$Subjectivity)
cor(tweet_data$Sentiment,as.numeric(tweet_data$Date))
cor(tweet_data$Subjectivity,as.numeric(tweet_data$Date))

tweet_data$std_sent = tweet_data$Sentiment - mean(tweet_data$Sentiment)
tweet_data$std_sub = tweet_data$Subjectivity - mean(tweet_data$Subjectivity)
tweet_data$sq_sent = tweet_data$std_sent*tweet_data$std_sent
tweet_data$sq_sub = tweet_data$std_sub*tweet_data$std_sub
tweet_data$std_date = tweet_data$numeric_date - mean(tweet_data$numeric_date)
tweet_data$sq_date = tweet_data$std_date*tweet_data$std_date

lin_reg = lm(Sentiment~Date,tweet_data)
reg = lm(Sentiment~std_date+sq_date,tweet_data)
summary(lin_reg)
summary(reg)

sub_lin_reg = lm(Subjectivity~Date,tweet_data)
sub_reg = lm(Subjectivity~std_date+sq_date,tweet_data)
summary(sub_lin_reg)
summary(sub_reg)

sub_lin_reg_sen = lm(Subjectivity~Sentiment,tweet_data)
sub_reg_sen = lm(Subjectivity~std_sent+sq_sent,tweet_data)
summary(sub_lin_reg_sen)
summary(sub_reg_sen)

ggplot(data=tweet_data, aes(x=Date, y=Sentiment)) +
  geom_point() +
  geom_smooth(method="lm", formula=y~x+I(x^2))

ggplot(data=tweet_data, aes(x=std_date, y=Subjectivity)) +
  geom_point() +
  geom_smooth(method="lm", formula=y~x+I(x^2))

ggplot(data=tweet_data, aes(x=std_sent, y=Subjectivity)) +
  geom_point() +
  geom_smooth(method="lm", formula=y~x+I(x^2))

ggplot(data=tweet_data, aes(x=std_sent, y=Subjectivity)) +
  geom_point() +
  geom_smooth(method="lm", formula=y~x)

# Some assumption checking!

# Influence
cutoff = 2*sqrt(2/nrow(data))
tweet_data$dffits = dffits(reg)
tweet_data$ï..Tweet[tweet_data$dffits >= cutoff]

cutoff = 2*sqrt(2/nrow(data))
tweet_data$dffits = dffits(sub_reg)
tweet_data$ï..Tweet[tweet_data$dffits >= cutoff]

cutoff = 2*sqrt(2/nrow(data))
tweet_data$dffits = dffits(sub_reg_sen)
tweet_data$ï..Tweet[tweet_data$dffits >= cutoff]

# Leverage and distance
tweet_data$lev = hat(model.matrix(reg))
tweet_data$ï..Tweet[tweet_data$lev >= 0.2]
tweet_data$distance = rstandard(reg)
tweet_data$ï..Tweet[tweet_data$distance >= 2.5]

tweet_data$lev = hat(model.matrix(sub_reg))
tweet_data$ï..Tweet[tweet_data$lev >= 0.2]
tweet_data$distance = rstandard(sub_reg)
tweet_data$ï..Tweet[tweet_data$distance >= 2.5]

tweet_data$lev = hat(model.matrix(sub_reg_sen))
tweet_data$ï..Tweet[tweet_data$lev >= 0.2]
tweet_data$distance = rstandard(sub_reg_sen)
tweet_data$ï..Tweet[tweet_data$distance >= 2.5]