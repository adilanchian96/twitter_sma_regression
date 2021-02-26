import re
import sys
import snscrape.modules.twitter as sntwitter
import pandas as pd
import csv
from tweepy import OAuthHandler
from textblob import TextBlob
from textblob.sentiments import NaiveBayesAnalyzer
from textblob.sentiments import PatternAnalyzer

# Implementation taken from https://www.geeksforgeeks.org/twitter-sentiment-analysis-using-python/
# Code contributed by GeeksforGeeks, improved by jaijaish98
# Edits for Regression FSU 2021 made by Andrew Dilanchian
# TextBlob: https://buildmedia.readthedocs.org/media/pdf/textblob/latest/textblob.pdf

class TwitterClient(object):
    def clean_tweet(self, tweet):
        return ' '.join(re.sub("(@[A-Za-z0-9]+)|([^0-9A-Za-z \t])|(\w+:\/\/\S+)", " ", tweet).split())
    
    def clean_date(self, date):
        return ' '.join(re.sub("[0-9]+:[0-9]+:[0-9]+\+[0-9]+:[0-9]+", "", str(date)).split())

    def get_tweet_sentiment(self, tweet):
        analysis = TextBlob(self.clean_tweet(tweet))
        # sentiment is -1 -> 0 -> 1 => negative, neutral, positive
        return (analysis.sentiment.polarity,analysis.sentiment.subjectivity)

    def get_tweets(self, query):
        for i, tweet in enumerate(sntwitter.TwitterSearchScraper("coronavirus lang:en since:2019-01-01 until:2021-01-01").get_items()):
            tweet_clean = self.clean_tweet(tweet.content)
            date_clean = self.clean_date(tweet.date)
            sent = self.get_tweet_sentiment(tweet_clean)
            with open('coronavirus.csv', 'a', newline='') as f:
                writer = csv.writer(f, delimiter=',')
                writer.writerow([tweet_clean, sent[0], sent[1], date_clean])    # 0 => polarity, 1 => subjectivity

if __name__ == "__main__": 
    api = TwitterClient() 
    api.get_tweets(query = None) # Takes in string CMD argument for query string
