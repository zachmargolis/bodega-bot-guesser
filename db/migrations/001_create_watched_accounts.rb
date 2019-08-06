Sequel.migration do
  up do
    create_table(:watched_accounts) do
      primary_key :id
      String :twitter_username, null: false, unique: true
      String :last_tweet_id, null: false
      DateTime :created_at
      DateTime :updated_at
    end
  end

  down do
    drop_table(:watched_accounts)
  end
end
