#!/usr/bin/env ruby

require 'twitter_ebooks'
require 'term/ansicolor'

#load config
begin
  require File.dirname(__FILE__) + '/config'
rescue LoadError
  STDERR.puts "Create a config.rb file first"
  exit
end

#monkeypatch of bot log function to add date
include Term::ANSIColor
module Ebooks
  class Bot
    def log(*args)
      t = Time.new
      timestamp = t.getlocal('-07:00') #TODO adjust per location
      STDERR.puts green(bold(timestamp.to_s)) + blue(bold(" @#{@username}: ")) + args.map(&:to_s).join(' ')
      STDERR.flush
    end
  end
end

#monkeypatch of Ebooks::Archive to use bot credentials
module Ebooks
  class Archive
    def make_client
      Twitter.configure do |config|
        config.consumer_key = BotConfig::CONSUMER_KEY
        config.consumer_secret = BotConfig::CONSUMER_SECRET
        config.oauth_token = BotConfig::OAUTH_TOKEN
        config.oauth_token_secret = BotConfig::OAUTH_TOKEN_SECRET
      end

      Twitter::Client.new
    end
  end
end

#setup the bot and configure its behavior
Ebooks::Bot.new('final140') do |bot|
  # Consumer details come from registering an app at https://dev.twitter.com/
  # OAuth details can be fetched with https://github.com/marcel/twurl
  bot.consumer_key = BotConfig::CONSUMER_KEY
  bot.consumer_secret = BotConfig::CONSUMER_SECRET
  bot.oauth_token = BotConfig::OAUTH_TOKEN
  bot.oauth_token_secret = BotConfig::OAUTH_TOKEN_SECRET

  bot.on_startup do
    self.run_archiver('inky')
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

  def self.run_archiver(handle)
    begin 
      Ebooks::Archive.new(handle,"corpus/#{handle}.json").sync
      Ebooks::Model.consume("corpus/#{handle}.json").save("model/#{handle}.model")  
    rescue
      self.log red("Unable to archive " + handle + " - private account?")
    end
  end
end

#start the bot(s)
EM.run do
  Ebooks::Bot.all.each do |bot|
    bot.start
  end
end

 
