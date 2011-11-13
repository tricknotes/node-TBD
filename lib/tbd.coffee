net = require('net')

class TBD
  constructor: (@sock, @argNames) ->
    @code = ""
    @result = null

    self = this
    @sock ||= "#{TBD.sockPath}/node-TBD-#{Number(new Date())}.sock"
    @argNames ||= []

  process: =>
    self = this
    args = arguments
    @server = net.createServer (socket) ->
      socket.on 'data', (data) ->
        self.code += data

      socket.on 'end', ->
        fn = eval("(function(#{self.argNames.join(',')}){return (#{self.code});})")
        self.result = fn.apply(null, args)

    @server.listen(@sock)

TBD.sockPath = '/tmp'

module.exports = (sock) ->
  (new TBD(sock)).process()

module.exports.TBD = TBD
