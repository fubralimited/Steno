
# ======================================================
# 	Gets new emails from imap account
# ======================================================

config = require '../config'
reeder = require './reader'
db     = require './db'

ImapConnection = require('imap').ImapConnection		# https://github.com/mscdex/node-imap

# Configure new iMap connection
imap = new ImapConnection
	username: config.email
	password: config.password
	secure: config.secure
	host: config.host
	port: config.port

# Start listening for connection close
imap.on 'close', ->
	elog 'Connection closed'
	do connect

# Immedittely connect
do connect = ->

	# Imap connecting
	elog 'Connecting'

	# Open connection
	imap.connect (err) ->

		# Log and return if error
		if err then elog err; return

		read = ->

			# Get undeleted messages
			imap.search ['UNDELETED'], (err, results) ->

				# Check results were returned
				return unless results.length

				# Start fetching messages as raw buffer
				fetch = imap.fetch results, request: body: 'full', headers: no

				# Listen for new message
				fetch.on 'message', (msg) ->

					# Buffer string
					msgBuffer = ''

					# Append buffer chunk
					msg.on 'data', (chunk) -> msgBuffer += chunk
					
					# Listen for end of message
					# Pass buffer to reader and reset buffer string
					msg.on 'end', ->
						reeder msgBuffer
						msgBuffer = ''

				# When all messages have been read close connection
				fetch.on 'end', ->
					# Delete messages and close connection once done
					imap.addFlags results, 'Deleted', (err) ->
						# Log and return if error
						if err then elog err

		# Open Inbox
		imap.openBox 'Inbox', no, (err, mailbox) ->

			# Log and return if error
			if err then elog err; return

			do read

			# Start listening for new mail
			imap.on 'mail', read