require 'logger'
require 'pathname'

module BodegaBotGuesser
  # @return [Pathname] path to the root of this project (version control root)
  def self.root
    Pathname.new(File.expand_path(File.join(__dir__, '..')))
  end

  LOGGER = Logger.new(STDOUT).tap do |logger|
    # heroku already captures the timestamp for log messages
    logger.formatter = proc do |severity, _datetime, _progname, msg|
      "#{severity} -- #{msg}\n"
    end
  end

  # @return [Logger]
  def self.logger
    LOGGER
  end
end
