require 'logger'

module BodegaBotGuesser
  def self.root
    File.expand_path(File.join(File.dirname(__FILE__), '..'))
  end

  LOGGER = Logger.new(STDOUT).tap do |logger|
    # heroku already captures the timestamp for log messages
    logger.formatter = proc do |severity, _datetime, _progname, msg|
      "#{severity} -- #{msg}\n"
    end
  end

  def self.logger
    LOGGER
  end
end
