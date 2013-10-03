
config = require '../config'

sqlite3 = require 'sqlite3'     # https://github.com/developmentseed/node-sqlite3

# ====================================================
#   Initialise db and create table if needed
# ====================================================

# Open database and create table if not set
db = new sqlite3.Database 'database.sqlite'

# Create table structure
tableStructure = """
    CREATE TABLE IF NOT EXISTS "emails" (
        "id" INTEGER PRIMARY KEY AUTOINCREMENT,
        "date" DATETIME DEFAULT (CURRENT_DATE),
        "user" VARCHAR(50),
        "email" VARCHAR(255),
        "message" TEXT
    ) """

# Execute create table and log if error
db.run tableStructure, (err) ->
    console.log 'Database ready'
    elog err if err

# ====================================================
#   Export db getter/setter
# ====================================================

module.exports =

    # Sets or updates today's message for user
    set: (email, message) -> # Save incoming message and overwrite if set

        db.run "UPDATE emails SET message=? WHERE date=date('now') AND email=?", message, email, (err) ->
            
            # Log any errors
            if err
                elog err
                return

            # Get usrname
            username = config.users[email]

            # Check Something was updated else INSERT
            unless @changes then db.run "INSERT INTO emails (user, email, message) VALUES (?,?,?)", username, email, message, (err) ->
                # Log any errors
                elog err if err

    # Simply gets all rows for today
    get: (callback) -> # Get Saved message of the day only else null

        db.all "SELECT * FROM emails WHERE date=date('now')", (err, rows) ->

            # Log any errors
            elog err if err

            # Pass rows to callback
            callback err, rows