require 'bodega_bot_guesser'
require 'dotenv'
require 'fileutils'
require 'rspec'

RSpec.configure do |config|
  config.before(:suite) do
    env_path = BodegaBotGuesser.root.join('.env')
    env_example_path = BodegaBotGuesser.root.join('.env.example')
    if !File.exists?(env_path)
      FileUtils.cp(env_example_path, env_path)
    end
    Dotenv.load(env_path)
  end
end
