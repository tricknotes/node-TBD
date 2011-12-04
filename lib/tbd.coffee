net = require('net')
repl = require('repl')

class TBD
  host: 'localhost'

  constructor: (@sock, @argNames) ->
    @sock ||= 13000
    @argNames ||= []

  process: =>
    sock = @sock
    args = arguments
    names = @argNames
    server = net.createServer (socket) ->
      started = repl.start('node-TBD> ', socket)

      for name, i in names
        started.context[name] = args[i]

      started.context.__stream = socket

      socket.on 'close', ->
        server.close() if server.connections == 0

    lisetnedSocket = null
    if typeof sock is 'number'
      server.listen(@sock, @host)
      lisetnedSocket = "#{@host}:#{sock}"
    else
      server.listen(@sock)
      lisetnedSocket = sock
    console.log("node-TBD listen on '#{lisetnedSocket}")

TBD.sockPath = '/tmp'

module.exports = (sock) ->
  (new TBD(sock)).process

module.exports.TBD = TBD
