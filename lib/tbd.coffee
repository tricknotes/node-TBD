net = require('net')
repl = require('repl')

class TBD
  constructor: (@sock, @argNames) ->
    @sock ||= "#{TBD.sockPath}/node-TBD-#{Number(new Date())}.sock"
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

    server.listen(@sock)
    console.log("node-TBD listen on '#{sock}'")

TBD.sockPath = '/tmp'

module.exports = (sock) ->
  (new TBD(sock)).process

module.exports.TBD = TBD
