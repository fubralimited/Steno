
# Load global logger
require './lib/logger'

moment = require 'moment' 					# https://github.com/timrwood/moment

# Dependancies
config = require './config'
outbox = require './lib/outbox'
inbox  = require './lib/inbox'
db     = require './lib/db'

cron   = require('cron').CronJob			# https://github.com/ncb000gt/node-cron

# ====================================================
# 	Schedule cron to send user emails
# ====================================================

# Function to send out user emails
sendUserMail = ->

	# Pretty date
	today = moment().format 'ddd, Do MMM'

	# Create signoff message with Friday condition
	signOff = if new Date().getDay() isnt 5 then 'Till tomorrow' else 'Till Monday - Have a good weekend!'

	# Messages array
	emails = []

	# Build emails
	for email, name of config.users
		emails.push
			to: email
			subject: "#{today} - What have you been up to today?"
			html: """Hi #{name},<br/>
				<p>Please reply to this email with a brief summary of what you have been doing today.</p>
				<span style="color:#999; font-weight: bold;">Remember to end your email with '--END--' if you are not using the standard signiture delimiter, '-- \n'.</span>
				<br/><span style="color:#999; font-weight: bold;">You can update your daily email at any time by simply replying to this email again.</span>
				<br/><br/><em>-- #{signOff}</em>"""

	# Send emails to outbox
	outbox emails

# Get minutes & hours from time obj
uTime = config.reminder.split ':'

# Create cron pattern
uCronPattern = "00 #{uTime[1]} #{uTime[0]} * * 1-5"

# Schedule cron
new cron uCronPattern, sendUserMail, null, yes

# ====================================================
# 	Schedule cron to send daily group email
# ====================================================

# Function to send out user emails
sendGroupMail = ->

	# Get all today's messages
	db.get (err, daily) ->

		# Check messages exist
		return if daily.length is 0
		
		# Body content
		body = ''

		# Build email body
		body += "<h3 style='margin:5px 0px;'>#{msg.user}</h3><p>#{msg.message}</p><br/>" for msg in daily

		# Build email
		groupEmail =
			to: config.group.email
			subject: "#{config.group.name} standup: #{daily[0].date}"
			html: body

		# Send email
		outbox groupEmail

# Get minutes & hours from time obj
gTime = config.group.time.split ':'

# Create cron pattern
gCronPattern = "00 #{gTime[1]} #{gTime[0]} * * 1-5"

# Schedule cron
new cron gCronPattern, sendGroupMail, null, yes

