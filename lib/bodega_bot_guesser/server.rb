require 'stringio'

module BodegaBotGuesser
  class Server
    def call(env)
      [
        200,
        {'Content-Type'=>'text/plain'},
        StringIO.new("Hello World!\n")
    ]
  end
end
