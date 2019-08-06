require 'rspec'
require 'dotenv'
require 'fileutils'
require 'bodega_bot_guesser'

RSpec.configure do |config|
  config.before(:suite) do
    env_path = File.join(BodegaBotGuesser.root, '.env')
    env_example_path = File.join(BodegaBotGuesser.root, '.env.example')
    if !File.exists?(env_path)
      FileUtils.cp(env_example_path, env_path)
    end
    Dotenv.load(env_path)
  end
end
