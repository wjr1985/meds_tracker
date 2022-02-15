require "active_support/core_ext/time"
require "active_support/core_ext/integer/time"
require "dotenv"
require "google/apis/sheets_v4"
require "googleauth"
require "googleauth/stores/file_token_store"

Dotenv.load

Dir.glob(File.join(__dir__, "meds_tracker_google_sheets", "**", "*.rb"), &method(:require))
