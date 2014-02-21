moment = require 'moment'                   # https://github.com/timrwood/moment

# Dependencies
config = require '../config'
outbox = require './outbox'
db     = require './db'

# Get all today's messages
db.get (err, daily) ->

    # Check messages exist
    return if daily.length is 0
    
    # Body content
    body = ''

    # Build email body
    body += "<p><h3 style='margin:5px 0px;'>#{msg.user}</h3>#{msg.message}</p>" for msg in daily

    # Build email
    groupEmail =
        to: config.group.email
        subject: "#{config.group.name} standup: #{daily[0].date}"
        html: body

    # Send email
    outbox groupEmail