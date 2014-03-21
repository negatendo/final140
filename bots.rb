#!/usr/bin/env ruby

require 'twitter_ebooks'
require_relative 'config'

Ebooks::Bot.new("final140") do |bot|
  # Consumer details come from registering an app at https://dev.twitter.com/
  # OAuth details can be fetched with https://github.com/marcel/twurl
  config.consumer_key = Config::CONSUMER_KEY
  config.consumer_secret = Config::CONSUMER_SECRET
  config.oauth_token = Config::OAUTH_TOKEN
  config.oauth_token_secret = Config::OAUTH_TOKEN_SECRET

  bot.on_message do |dm|
    # Reply to a DM
    # bot.reply(dm, "secret secrets")
  end

  bot.on_follow do |user|
    # attempt to index tweets
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
    # Tweet some number of last-tweets every hour
  end
end
