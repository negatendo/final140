#!/usr/bin/env ruby

require 'twitter_ebooks'

begin
  require File.dirname(__FILE__) + '/config'
rescue LoadError
  STDERR.puts "Create a config.rb file first"
  exit
end

Ebooks::Bot.new('final140') do |bot|
  # Consumer details come from registering an app at https://dev.twitter.com/
  # OAuth details can be fetched with https://github.com/marcel/twurl
  bot.consumer_key = BotConfig::CONSUMER_KEY
  bot.consumer_secret = BotConfig::CONSUMER_SECRET
  bot.oauth_token = BotConfig::OAUTH_TOKEN
  bot.oauth_token_secret = BotConfig::OAUTH_TOKEN_SECRET

  bot.on_startup do
    bot.tweet('hello world')
  end

  bot.on_message do |dm|
    # Reply to a DM
    # bot.reply(dm, "secret secrets")
  end

  bot.on_follow do |user|
    # TODO attempt to index tweets of new followers

  end

  bot.on_mention do |tweet, meta|
    # Reply to a mention
    # bot.reply(tweet, meta[:reply_prefix] + "oh hullo")
  end

  bot.on_timeline do |tweet, meta|
    # Reply to a tweet in the bot's timeline
    # bot.reply(tweet, meta[:reply_prefix] + "nice tweet")
  end

  bot.scheduler.every '1h' do
    # TODO Tweet the last tweet of n+ people every hour
    #
    # - generate markov text from corpus
    # - generate image of tweet
    # - tweet image @ follower
  end
end

#start yr engines
EM.run do
  Ebooks::Bot.all.each do |bot|
    bot.start
  end
end
 
