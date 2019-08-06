require 'bodega_bot_guesser'
require 'sequel'
require 'uri'

module BodegaBotGuesser
  class DB
    Sequel::Model.plugin :timestamps

    def self.database_url
      ENV['DATABASE_URL']
    end

    def self.database_name
      URI.parse(database_url).path.gsub(%r|^/|, '')
    end

    def self.connection
      @connection ||= Sequel.connect(database_url)
    end

    def self.migrate
      Sequel.extension :migration
      Sequel::Migrator.run(connection, migrations_path)
    end

    def self.migrations_path
      File.join(BodegaBotGuesser.root, 'db', 'migrations')
    end

    WatchedAccount = Struct.new(:last_tweet_id, :twitter_username)

    # @return [WatchedAccount]
    def self.load_watched_account(username)
      row = connection[:watched_accounts].
        where(twitter_username: username).
        first

      WatchedAccount.new.tap do |watched_account|
        watched_account.last_tweet_id = row && row[:last_tweet_id]
        watched_account.twitter_username = (row && row[:twitter_username]) || username
      end
    end

    def self.update_watched_account(twitter_username:, last_tweet_id:)
      connection[:watched_accounts].
        insert_conflict(
          target: :twitter_username,
          update: {
            last_tweet_id: last_tweet_id,
            updated_at: Sequel::CURRENT_TIMESTAMP
          }
        ).insert(
          last_tweet_id: last_tweet_id,
          twitter_username: twitter_username,
          created_at: Sequel::CURRENT_TIMESTAMP,
          updated_at: Sequel::CURRENT_TIMESTAMP
        )
    end
  end
end
