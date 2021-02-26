import snscrape.modules.twitter as sntwitter
import pandas as pd
import itertools

# Setting variables to be used below
maxTweets = 100
# Creating list to append tweet data to
tweets_list2 = []
# Using TwitterSearchScraper to scrape data and append tweets to list
for i,tweet in enumerate(sntwitter.TwitterSearchScraper("'trump' since:2019-01-01 until:2020-01-01").get_items()):
    if i>maxTweets:
        break
    tweets_list2.append([tweet.date, tweet.id, tweet.content, tweet.username])
# Creating a dataframe from the tweets list above
tweets_df2 = pd.DataFrame(tweets_list2, columns=['Datetime', 'Tweet Id', 'Text', 'Username'])
# Display first 5 entries from dataframe
print(tweets_df2.head())