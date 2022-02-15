require "dotenv"
Dotenv.load

require_relative "lib/meds_tracker_google_sheets"

GoogleSheets::Authorization.authorize
