sys = require 'sys'
connect = require 'connect'

serveStatic = require 'serve-static'
logger = require 'connect-logger'
session = require 'express-session'
browserify = require 'browserify-middleware'

# Board = require './board'
Room = require './room'


Kriegspiel = (options = {}) ->
  return new arguments.callee arguments unless (this instanceof arguments.callee)

  settings = port: options.port or 8124
  sockets = {}
  rooms = []
  # rooms = {lobby: new Room('lobby')}



  createServer = ->
    server = connect()
    http = require('http').createServer(server)
    server.use serveStatic(process.cwd() + '/public')
    server.use logger()
    server.use session(secret: 'WarGames')
    server.use '/require.js', browserify ['./board.coffee'], basedir: './lib', transform: [require('coffeeify')]

    io = (require 'socket.io')(http)

    createRoom = ->
      roomNumber = rooms.length + 1
      channel = io.of('/rooms/' + roomNumber)
      room = new Room(channel)
      rooms.push room

    createRoom(io)
    io.sockets.on 'connection', (socket) ->
      # join first room when connected
      socket.emit "room.join", rooms[0].channel.name, rooms[0].board

      socket.on "room.create", ->
        createRoom(io)

    return http

  server = createServer()
  # (require './comm').initialize server
  server.listen settings.port

  sys.log 'Server started on port ' + settings.port

module.exports = Kriegspiel
