# Steno

### Steno collaborates daily group tasks into a single email.

---


#####Removed all js crons in favour of simply setting more reliable crontab entries.

Set inbox to be cleared every 15min

	*/15 * * * * coffee /Steno/lib/inbox.coffee >> /Steno/cron.log

Send daily group email at 17:05 every weekday (05 to ensure 17:00 the inbox will cleared)

	5 17 * * 1-5 coffee /Steno/lib/sendgroup.coffee >> /Steno/cron.log

Send individual email reminders at 14:30 every weekday

	0 14 * * 1-5 coffee /Steno/lib/senduser.coffee >> /Steno/cron.log


---

To get started, create a config file *(sample_config.coffee is provided)* in any commonjs module format e.g. JavaScript, JSON, CoffeeScript.


	// List individual group users
	users:
	  |
	  ├── 'user1@example.com' : user1
	  └── 'user2@example.com' : user2
	
	// Time to email users with reminder email
	reminder: '14:00'
	
	// Group details include:
	// Team name to include in daily group email title
	// Team email address to send daily collaborated email to
	// Time to sen out daily collaborated email
	group:
	  |
	  ├── name:  'Team name'
	  ├── email: 'team@example.com'
	  └── time:  '17:00'
	
	// iMap account details	  
	provider: 'Gmail'
	email: 'steno_account@gmail.com'
	password: 'supersecretpassword'
	host: 'imap.gmail.com'
	secure: true
	port: 993
	

To start Steno, simply install dependancies with `npm install` and then run the steno.coffee file with either [Forever](https://github.com/nodejitsu/forever), [Upstart](http://upstart.ubuntu.com/) or similar.

**The package.json file includes some standard startup methods:**

- `npm run-script deploy` to start the app as a daemon with it's own local copy of **Forever** and **CoffeeScript**.
- `npm run-script list` to check all **Forever** running processes.
- `npm run-script kill` to stop *ALL* running **Forever** processes.
	
Steno will immediattely process and delete any new emails on the selected imap account, so use a dedicated email account.

Only Gmail has been tested, but any imap account should work.

#### Updating daily email

Individual daily tasks can be updated at any time before midnight by simply replying to again.

#### Email signatures

Email signatures will be stripped at either the custom **--END--** delimiter or the standard **--[space][newline]** email delimiter.

#### Archived messages

Messages are stored in a sqlite database at the root of the Steno directory.