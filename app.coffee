# Module dependencies.

express = require 'express'
ss = require 'socketstream'
mongoose = require 'mongoose'
fs = require 'fs'

# mongoose configuration

#mongoose.connect 'mongodb://localhost/musejs'
#Album = mongoose.model 'album', require './server/models/album'

app = module.exports = express.createServer() # create the express server

# SocketStream Configuration

ss.client.define 'main', {
	view: 'app.jade'
	code: ['libs', 'app'],
	css: 'app.styl',
	tmpl: '*'
}

ss.client.define 'test', {
	view: 'app.jade'
	code: ['libs', 'app', 'tests', 'tests/libs'],
	css:  ['app.styl', 'mocha/mocha.css'],
	tmpl: '*'
}

ss.client.formatters.add require 'ss-coffee'
ss.client.formatters.add require 'ss-stylus'
ss.client.formatters.add require 'ss-jade'
ss.client.templateEngine.use require 'ss-jade'

#ss.responders.add require './server/backbone/server/index'
#ss.client.packAssets()

# Express Configuration

app.configure ->
	app.use express.bodyParser()
	app.use express.methodOverride()
	app.use app.router
	app.use ss.http.middleware
	app.use express.static __dirname + '/public' # serve static files from public

app.configure 'development', ->
	app.use express.errorHandler { dumpExceptions: true, showStack: true } # show errors in development

app.configure 'production', ->
	app.use express.errorHandler { dumpExceptions: false, showStack: false } # not in production

app.get '/', (req, res) -> # when the index is requested, render the view with jade
	res.serve 'main'


app.get '/test', (req, res) -> # when the index is requested, render the view with jade
	res.serve 'test'
	ss.client.send('lib', 'mocha', fs.readFileSync("./node_modules/mocha/mocha.js"))

#	res.render 'index'

#app.post '/upload', (req, res, next) -> 
#
#	parser = new meta fs.createReadStream req.files.track.path
#	parser.on 'metadata', (result) ->
#		console.log(result)
#	res.render 'index'

app.listen 3000 # listen on port 3000
console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env

ss.start app