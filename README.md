# meds_tracker_google_sheets

This is a simple program that responds to HTTP requests by updating a Google Spreadsheet. It's primary purpose is to help track when medication is taken, when the effects of the medication start, and when they end, and is designed to fit into a spreadsheet designed with 5 columns - date, taken time, start time, end time, and a column for a difference between end time and start time (duration).

## Prerequisites

- Ruby 3.1.1
- A Google Cloud project and OAuth credentials with that project. First, read the instructions [here](https://developers.google.com/workspace/guides/create-project) to create a Google Cloud project. Next, follow the instructions [here](https://developers.google.com/workspace/guides/create-credentials#desktop-app) on how to set up OAuth Client ID credentials for a Desktop app. Once created, you'll want to download the credentials file for use later on. Do **not** ever commit this or otherwise make it publicly avaialble.
- A Google Sheet with headers already set up. The headers can be whatever you want, but the script will assume something like `date,taken,start,end,duration`.
- The ID of the above Google sheet - if you're unsure of the ID for the Google Sheet, the ID is the part of the url between `/d/` and `/edit` (so in the following example https://docs.google.com/spreadsheets/d/abcdefghijklmnop/edit#gid=0, the ID would be `abcdefghijklmnop`)
- Linux or MacOS if not running in Docker

Important note: With your Google Cloud project, you'll want to go to the [OAuth consent screen](https://console.cloud.google.com/apis/credentials/consent) configuration and change `Publishing status` to production. You'll receive a warning or a notice about needing to verify your application - you can ignore this and continue. If using this for personal use, you'll receive a warning when authenticating later on indicating that the application isn't verified, but you can continue anyway. If you do not do this, your application authorization will only last for 7 days.

## Setup

### Docker

TBD

### Setting up for running locally

To run this locally, first run `bundle install` to install everything.

Then, you'll want to create an `.env` file with the following:

- `GOOGLE_CREDS_PATH` - the path to the credentials file that you downloaded in the prerequisites section above
- `TOKEN_PATH` - a path to where the result of authenticating will be stored - this will be a YAML file.
- `SHEET_ID` - the ID of the Google Sheet from the prerequisites section above

## Authorizing your user

Once you have Docker or your local set up created, you'll want to authorize your user. To do this, run the following:

For Docker: `TBD`

For running locally: `bundle exec ruby authorize.rb`

This will generate a link for you to click on, and then will start Webrick to listen to the OAuth response. Unfortunately, the OAuth out-of-band (OOB) flow has been removed by Google (more information [here](https://developers.googleblog.com/2022/02/making-oauth-flows-safer.html#disallowed-oob)), so the old method of copy-pasting the OAuth code no longer works.

Once the authorization code receives the callback, it will automatically get the code from the request, and complete authorization. If you're not running this on the same machine that you opened the browser on, you'll want to port forward `5151` to your local machine from whatever machine that `meds_tracker_google_sheets` is running on.

## Starting

To start using Docker, run `TBD`

To start running locally, run `bundle exec ruby main.rb`

Both will start Sinatra listening on port `4567`.

## Using

The primary purpose of this was to be used by iOS Shortcuts to easily trigger the application. You can find the shortcuts here:

- Add taken: TBD
- Start: TBD
- End: TBD

You can also POST to `/add_taken`, `/add_start`, and `/add_end` to record when the medication was taken, effects started, and effects ended.

When `/add_end` is called, it will automatically add values in the `duration` column.


## TODO

These are in no specific order

- [ ] Finish Docker setup
- [ ] Publish iOS Shortcuts
- [ ] Handle when taken, start, or end crosses a date boundary (a.k.a. don't assume that all meds are taken, start, and end on the same day)
- [ ] Allow customization of the columns used for date, taken, start, end, and duration
- [ ] Code cleanup around indexes
- [ ] User interface so that this doesn't rely only on iOS Shortcuts or a separate application calling it
- [ ] Handle if unable to port forward 5151 to your local machine during authorization

## Contributing

Want to contribute? Feel free to create a merge request [here](https://gitlab.com/wjr1985/meds_tracker_google_sheets/-/merge_requests), or report an issue [here](https://gitlab.com/wjr1985/meds_tracker_google_sheets/-/issues). If you contribute a merge request, you'll be listed in the README.

## License

MIT