
config     = require '../config'

nodemailer = require 'nodemailer'			# http://www.nodemailer.com/
async      = require 'async'				# https://github.com/caolan/async

# ================================================
# 	Mail option example
# ================================================
# 
# from: 'Fred Foo <foo@blurdybloop.com>'
# to: 'bar@blurdybloop.com, baz@blurdybloop.com'
# subject: 'Hello'
# text: 'Hello world'
# html: '<b>Hello world</b>'
# 
# ================================================

# Takes single/array of email objects and send them out in parallel
module.exports = (emails) ->

	# Creates smtp transport
	transport = nodemailer.createTransport 'smtp',
		service: config.provider
		auth:
			user: config.email
			pass: config.password

	# Method to send email with given transport
	send = (email, done) ->

		# Add/override from field
		email.from = "Steno <#{config.email}>"

		# Send email
		transport.sendMail email, (err, res) ->
			# Call done with err.
			# If err is set it will be set in async callback
			done err

	# Send single email if not array
	unless emails instanceof Array then send emails, (err) ->
			# Log error if exists else close transport
			if err then console.log(err) else do transport.close

	# Else send each email in parallel and close tranport when done
	else async.forEach emails, send, (err) ->
			# Log error if exists else close transport
			if err then console.log(err) else do transport.close
		
		






