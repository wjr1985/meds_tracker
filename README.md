# meds_tracker

This is a simple program that responds to HTTP requests by updating a Google Spreadsheet. It's primary purpose is to help track when medication is taken, when the effects of the medication start, and when they end, and is designed to fit into a spreadsheet designed with 5 columns - date, taken time, start time, end time, and a column for a difference between end time and start time (duration).

## ⚠️ Work in progress

This is very much so a work in progress. It works for me for my daily use, but could have some bugs still.

## Prerequisites

- Ruby 3.1.x OR Docker
- A Google Cloud project and OAuth credentials with that project. First, read the instructions [here](https://developers.google.com/workspace/guides/create-project) to create a Google Cloud project. Next, follow the instructions [here](https://developers.google.com/workspace/guides/create-credentials#desktop-app) on how to set up OAuth Client ID credentials for a Desktop app. Once created, you'll want to download the credentials file for use later on. Do **not** ever commit this or otherwise make it publicly avaialble.
- A Google Sheet with headers already set up. The headers can be whatever you want, but the script will assume something like `date,taken,start,end,duration`.
- The ID of the above Google sheet - if you're unsure of the ID for the Google Sheet, the ID is the part of the url between `/d/` and `/edit` (so in the following example https://docs.google.com/spreadsheets/d/abcdefghijklmnop/edit#gid=0, the ID would be `abcdefghijklmnop`)
- Linux or MacOS if not running in Docker (this has not been tested in Windows)

Important note: With your Google Cloud project, you'll want to go to the [OAuth consent screen](https://console.cloud.google.com/apis/credentials/consent) configuration and change `Publishing status` to production. You'll receive a warning or a notice about needing to verify your application - you can ignore this and continue. If using this for personal use, you'll receive a warning when authenticating later on indicating that the application isn't verified, but you can continue anyway. If you do not do this, your application authorization will only last for 7 days.

## Setup

### .env file

Docker and local execution both will need to use an .env file. You'll want to create an `.env` file with the following:

- `GOOGLE_CREDS_PATH` - the path to the credentials file that you downloaded in the prerequisites section above. This should be somewhere in the current working directory.
- `TOKEN_PATH` - a path to where the result of authenticating will be stored - this will be a YAML file. This should be somewhere in the current working directory.
- `SHEET_ID` - the ID of the Google Sheet from the prerequisites section above
- `TZ` - The time zone that you want to use when determining dates and times when writing to the spreadsheet (example, `TZ=America/Chicago`)

### Docker Compose

Docker Compose is supported.

### Docker

You'll want to run `docker build -t meds_tracker:latest .` to build the image. Note that in the .env file created above, `GOOGLE_CREDS_PATH` and `TOKEN_PATH` should specify a subdirectory (so something like `GOOGLE_CREDS_PATH=creds/credentials.json`).

### Setting up for running locally

To run this locally, first run `bundle install` to install everything.

Then, you'll want to create an `.env` file with the following:

- `GOOGLE_CREDS_PATH` - the path to the credentials file that you downloaded in the prerequisites section above
- `TOKEN_PATH` - a path to where the result of authenticating will be stored - this will be a YAML file.
- `SHEET_ID` - the ID of the Google Sheet from the prerequisites section above

## Authorizing your user

Once you have Docker or your local set up created, you'll want to authorize your user. To do this, run the following:

For Docker Compose: `docker compose run authorize`

For Docker: `docker run --env-file .env -v ${PWD}/creds:/app/creds -ti meds_tracker:latest bundle exec ruby authorize.rb`, replacing `meds_tracker:latest` with the image 

For running locally: `bundle exec ruby authorize.rb`

This will generate a link for you to click on, and then will start Webrick to listen to the OAuth response. Unfortunately, the OAuth out-of-band (OOB) flow has been removed by Google (more information [here](https://developers.googleblog.com/2022/02/making-oauth-flows-safer.html#disallowed-oob)), so the old method of copy-pasting the OAuth code no longer works.

Once the authorization code receives the callback, it will automatically get the code from the request, and complete authorization. If you're not running this on the same machine that you opened the browser on, you'll want to port forward `5151` to your local machine from whatever machine that `meds_tracker` is running on.

## Starting

To start using Docker Compose, run `docker compose up`.

To start using Docker, run: `docker run --env-file .env -v ${PWD}/creds:/app/creds -p 4567:4567 meds_tracker:latest`, replacing `meds_tracker:latest` with the image name, and `creds` with the credentials directory. Alternatively, you could run:

```
docker run \
  -e GOOGLE_CREDS_PATH=creds/credentials.json \
  -e TOKEN_PATH=creds/token.yaml \
  -e SHEET_ID=abcdefg1234567 \
  -v ${PWD}/creds:/app/creds \
  -p 4567:4567 \
  meds_tracker:latest
```

To start running locally, run `bundle exec ruby main.rb`

All of the above will start Sinatra listening on port `4567`.

## Using

The primary purpose of this was to be used by iOS / macOS Shortcuts to easily trigger the application. You can find the shortcuts here:

- Add taken: [https://www.icloud.com/shortcuts/627e808c222f47da87d73c374d4e8694](https://www.icloud.com/shortcuts/627e808c222f47da87d73c374d4e8694)
- Start: [https://www.icloud.com/shortcuts/c692b6de3ec24946aa899e98e65ea7ed](https://www.icloud.com/shortcuts/c692b6de3ec24946aa899e98e65ea7ed)
- End: [https://www.icloud.com/shortcuts/d145395575f44a5bb5856ec9a24ddba6](https://www.icloud.com/shortcuts/d145395575f44a5bb5856ec9a24ddba6)

The shortcuts above will prompt you for where `meds_tracker` is running - you'll want to input it like `http://localhost:4567`, without an ending `/`.

If you don't want to or can't use iOS / macOS Shortcuts, you can also POST to `/add_taken`, `/add_start`, and `/add_end` to record when the medication was taken, effects started, and effects ended.

When `/add_end` is called, it will automatically add values in the `duration` column.


## TODO

These are in no specific order

- [x] Finish Docker setup
- [ ] Publish Docker image
- [x] Publish iOS Shortcuts
- [ ] Handle when taken, start, or end crosses a date boundary (a.k.a. don't assume that all meds are taken, start, and end on the same day)
- [ ] Allow customization of the columns used for date, taken, start, end, and duration
- [x] Code cleanup around indexes
- [ ] User interface so that this doesn't rely only on iOS / macOS Shortcuts or a separate application calling it
- [ ] Handle if unable to port forward 5151 to your local machine during authorization

## Contributing

Want to contribute? Feel free to create a pull request [here](https://github.com/wjr1985/meds_tracker/pulls), or report an issue [here](https://github.com/wjr1985/meds_tracker/issues). If you contribute a pull request, you'll be listed in the README.

## License

MIT
