require_relative "lib/meds_tracker_google_sheets"
require "sinatra"

set :bind, "0.0.0.0"

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
