require 'twitter'

module BodegaBotGuesser
  class Twitter
    attr_reader :api

    def initialize
      @api = build_api
    end

    def tweets_since(username:, last_tweet_id: nil)
      options = {
        exclude_replies: false,
        include_rts: false,
        count: 50
      }

      if last_tweet_id
        options[:since_id] = last_tweet_id
      end

      api.user_timeline(username, options)
    end

    def reply(text:, tweet_id:)
      api.update!(text, in_reply_to_status_id: tweet_id)
    end

    def quote_tweet(text:, tweet_url:)
      api.update!("#{text}\n#{tweet_url}", attachment_url: tweet_url)
    end

    # @api private
    def build_api
      ::Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['TWITTER_API_CONSUMER_KEY']
        config.consumer_secret     = ENV['TWITTER_API_CONSUMER_SECRET']
        config.access_token        = ENV['TWITTER_API_ACCESS_TOKEN']
        config.access_token_secret = ENV['TWITTER_API_ACCESS_SECRET']
      end
    end
  end
end
