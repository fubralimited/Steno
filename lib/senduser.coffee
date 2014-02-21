moment = require 'moment'                   # https://github.com/timrwood/moment

# Dependencies
config = require '../config'
outbox = require './outbox'
db     = require './db'

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
            <p>Please reply to this email before #{config.group.time} with a brief summary of what you have been doing today.</p>
            <span style="color:#999; font-weight: bold;">Remember to end your email with '--END--' if you are not using the standard signature delimiter, '-- \n'.<br/>Alternatively, remove your email signature before replying.</span>
            <br/><span style="color:#999; font-weight: bold;">You can update your daily email at any time by simply replying to this email again.</span>
            <br/><br/><em>-- #{signOff}</em>"""

# Send emails to outbox
outbox emails