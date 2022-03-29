require "dotenv"
Dotenv.load

require "active_support/core_ext/time"
require "active_support/core_ext/integer/time"
require "google/apis/sheets_v4"
require "googleauth"
require "googleauth/stores/file_token_store"

Dir.glob(File.join(__dir__, "meds_tracker", "**", "*.rb"), &method(:require))
