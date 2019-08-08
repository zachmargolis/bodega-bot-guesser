require 'spec_helper'
require 'bodega_bot_guesser/db'

RSpec.describe BodegaBotGuesser::DB do
  before(:all) do
    begin
      BodegaBotGuesser::DB.connection
    rescue Sequel::DatabaseConnectionError
      Sequel.connect('postgres://localhost/postgres') do |db|
        db.execute "DROP DATABASE IF EXISTS %s" % [db.quote_identifier(BodegaBotGuesser::DB.database_name)]
        db.execute "CREATE DATABASE %s" % [db.quote_identifier(BodegaBotGuesser::DB.database_name)]
      end
    end
    BodegaBotGuesser::DB.migrate
  end

  after(:each) do
    BodegaBotGuesser::DB.connection[:watched_accounts].truncate
  end

  describe '.load_watched_account' do
    it 'returns an object with a nil last tweet where nothing exists' do
      watched_account = BodegaBotGuesser::DB.load_watched_account('aaa')
      expect(watched_account.twitter_username).to eq('aaa')
      expect(watched_account.last_tweet_id).to eq(nil)
    end

    it 'returns a last tweet id if one exists' do
      BodegaBotGuesser::DB.update_watched_account(twitter_username: 'aaa', last_tweet_id: '444')

      watched_account = BodegaBotGuesser::DB.load_watched_account('aaa')
      expect(watched_account.twitter_username).to eq('aaa')
      expect(watched_account.last_tweet_id).to eq('444')
    end
  end

  describe '.update_watched_account' do
    it 'does an upset and updates the last tweet id' do
      BodegaBotGuesser::DB.update_watched_account(twitter_username: 'bbb', last_tweet_id: '111')
      expect(BodegaBotGuesser::DB.load_watched_account('bbb').last_tweet_id).to eq('111')
      BodegaBotGuesser::DB.update_watched_account(twitter_username: 'bbb', last_tweet_id: '222')
      expect(BodegaBotGuesser::DB.load_watched_account('bbb').last_tweet_id).to eq('222')
    end
  end
end
