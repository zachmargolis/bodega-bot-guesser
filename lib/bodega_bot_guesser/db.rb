require 'bodega_bot_guesser'
require 'sequel'

module BodegaBotGuesser
  class DB
    Sequel::Model.plugin :timestamps

    CONNECTION = Sequel.connect(ENV['DATABASE_URL'])

    def self.connection
      CONNECTION
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

    # @param watched_account [WatchedAccount]
    # @param new_last_tweet_id [String]
    def self.update_watched_account(watched_account, new_last_tweet_id)
      connection[:watched_accounts].
        insert_conflict(
          target: :twitter_username,
          update: {
            last_tweet_id: new_last_tweet_id,
            updated_at: Sequel::CURRENT_TIMESTAMP
          }
        ).insert(
          last_tweet_id: new_last_tweet_id,
          twitter_username: watched_account.twitter_username,
          created_at: Sequel::CURRENT_TIMESTAMP,
          updated_at: Sequel::CURRENT_TIMESTAMP
        )
    end
  end
end
