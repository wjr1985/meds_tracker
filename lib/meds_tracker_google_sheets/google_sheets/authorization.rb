require "webrick"

module GoogleSheets
  class Authorization
    OAUTH_URI = "http://localhost:5151/".freeze
    SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS

    def self.credentials(force: false)
      @credentials ||= begin
        creds = authorizer.get_credentials(user_id)
        error_message = "Unable to find Google Credentials file at '#{ENV['GOOGLE_CREDS_PATH']}'. Make sure the env variable GOOGLE_CREDS_PATH is set. If you have not authorized yet, run 'ruby authorize.rb' to authorize first."
        raise error_message if !force && creds.nil?

        creds
      end
    end

    def self.authorize
      if credentials(force: true).nil?
        url = authorizer.get_authorization_url(base_url: OAUTH_URI)
        puts "Open the following URL in the browser:\n#{url}"
        puts "\n"
        puts "Webrick will start to listen for the oauth response"
        puts "If you're running this on a remote machine, port forward 5151 to your local machine"
        server = WEBrick::HTTPServer.new(:Port => 5151)

        server.mount('', AuthorizeResponse)
        trap('INT') {server.shutdown}
        server.start


        authorizer.get_and_store_credentials_from_code(
          user_id: user_id, code: AuthorizeResponse.auth_code, base_url: OAUTH_URI
        )
      else
        puts "Already authorized"
      end
    end

    def self.client_id
      Google::Auth::ClientId.from_file(ENV["GOOGLE_CREDS_PATH"])
    end

    def self.token_store
      Google::Auth::Stores::FileTokenStore.new(file: ENV["TOKEN_PATH"])
    end

    def self.authorizer
      @authorizer ||= Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
    end

    def self.user_id
      @user_id ||= (ENV["GOOGLE_USER_ID"] || "default")
    end
  end
end
