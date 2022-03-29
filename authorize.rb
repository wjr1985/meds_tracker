require "dotenv"
Dotenv.load

require_relative "lib/meds_tracker"

MedsTracker::GoogleSheets::Authorization.authorize
