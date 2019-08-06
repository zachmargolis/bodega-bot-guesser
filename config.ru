lib = File.join(__dir__, 'lib')
$LOAD_PATH.unshift(lib)

require 'bodega_bot_guesser/server'

run BodegaBotGuesser::Server.new
