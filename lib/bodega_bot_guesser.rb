require 'logger'

module BodegaBotGuesser
  def self.root
    File.expand_path(File.join(File.dirname(__FILE__), '..'))
  end

  LOGGER = Logger.new(STDOUT)

  def self.logger
    LOGGER
  end
end
