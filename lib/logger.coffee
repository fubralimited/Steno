# ====================================================
# 	Create global logging method
# ====================================================

# https://github.com/timrwood/moment
moment = require 'moment'

# Create  :( global ): log method
if global.elog then console.log 'logging cannot be set to global namespace'
else global.elog = (message) ->
	
	# Get time
	stamp = moment().format 'DD-MM-YY HH:mm:ss'
	
	# Format message with date
	message = "[ #{stamp} ] #{message}\n\r\n\r"
	
	# Write line
	require('fs').appendFile 'error.log', message