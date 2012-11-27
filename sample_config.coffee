module.exports =
# Basic configuration for Steno users, out email, schedule etc.

	# List users to receive daily reply-to email
	# Format: { email : name }
	users:

		'user1@example.com' : 'User1'
		'user2@example.com' : 'User2'
		'user3@example.com' : 'User3'

	# Time to email users' daily email
	# Format is 24-hour
	# e.g. 16:50
	reminder: '14:00'

	# Group email to send compiled daily email to.
	group:

		# Name of group
		name: 'Example Group'

		# Group email to send compiled daily email
		email: 'group@example.com'

		# Time to email compiled daily email
		# Format is 24-hour
		# e.g. 16:50
		time: '16:20'

	# iMap account details
	provider: 'Gmail'
	email: 'steno_group@gmail.com'
	password: 'gmail_password'
	host: 'imap.gmail.com'
	secure: yes
	port: 993