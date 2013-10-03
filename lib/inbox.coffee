
# ======================================================
# 	Gets new emails from imap account
# ======================================================

config = require '../config'
reeder = require './reader'
db     = require './db'

refreshRate = 5 # Interval of minutes to refresh

Imap = require 'imap'		# https://github.com/mscdex/node-imap

# Configure new iMap connection
imap = new Imap
	user: config.email
	password: config.password
	tls: config.secure
	host: config.host
	port: config.port
	tlsOptions: { rejectUnauthorized: no }

connect = ->

	do imap.connect

	imap.once 'ready', ->
		
		# Open Inbox
		imap.openBox 'Inbox', no, (err, mailbox) ->

			# Log and return if error
			if err then elog err; return

			# Get undeleted messages
			imap.search ['UNDELETED'], (err, results) ->

				# Check results were returned
				return unless results.length

				# Start fetching messages as raw buffer
				fetch = imap.fetch results, { bodies: '' }

				# Listen for new message
				fetch.on 'message', (msg) ->

					# Buffer string
					msgBuffer = ''

					# Append buffer chunk
					msg.on 'body', (stream) ->

						stream.on 'data', (chunk) -> msgBuffer += chunk
					
					# Listen for end of message
					# Pass buffer to reader and reset buffer string
					msg.once 'end', ->
						reeder msgBuffer
						msgBuffer = ''

				# When all messages have been read close connection
				fetch.once 'end', ->
					# Delete messages and close connection once done
					imap.addFlags results, 'Deleted', (err) ->
						# Log and return if error
						if err then elog err
						do imap.end


imap.once 'error', (err) ->
  console.log err

imap.once 'end', ->
  console.log 'Connection ended'

# Get inbox once
do connect

# Create timer to read messages every 5 minutes
setInterval connect, ( 60000 * refreshRate )
