require 'grackle'

class Tweet < ActiveRecord::Base
  attr_accessible :content, :created
  MY_APPLICATION_NAME = "OSCAR_FAMILY"
  
  """Connect to the Twitter API and pull down the latest tweets"""
  def self.get_latest
    tweets = client.statuses.user_timeline? :screen_name => MY_APPLICATION_NAME # hit the API
    tweets.each do |t|
      created = DateTime.parse(t.created_at)
      # create the tweet if it doesn't already exist
      unless Tweet.exists?(["created=?", created])
        Tweet.create({:content => t.text, :created => created })
       end
    end
  end
  
  private
  def self.client
    Grackle::Client.new(:auth=>{
      :type=>:oauth,
      :consumer_key=>ENV['TWITTER_CONSUMER_KEY'],
      :consumer_secret=>ENV['TWITTER_CONSUMER_SECRET'],
      :token=>ENV['TWITTER_TOKEN'],
      :token_secret=>ENV['TWITTER_TOKEN_SECRET']
    })

  end
end
