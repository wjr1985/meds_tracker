require_relative "lib/meds_tracker_google_sheets"
require "sinatra"

set :bind, "0.0.0.0"

# When using with iOS Shortcuts, we have to disable showing exceptions
# and set custom errors with the error code, so they can be parsed.
# iOS Shortcuts do not allow you to get the HTTP status (as of iOS 15.3.1)
#
# These error pages can be customized further, as long as they have "500"
# and "404" in them respectively
disable :show_exceptions

error do
  "500"
end

error 404 do
  "404"
end

post "/add_taken" do
  meds_sheet.add_taken
end

post "/add_start" do
  meds_sheet.add_start
end

post "/add_end" do
  meds_sheet.add_end
end

def meds_sheet
  @meds_sheet ||= GoogleSheets::Sheet.new(
    sheet_id: ENV["SHEET_ID"]
  )
end
