require "webrick"

module GoogleSheets
  class AuthorizeResponse < WEBrick::HTTPServlet::AbstractServlet
    attr_reader :auth_code, :webrick_server

    def self.get_instance(server)
      @instance ||= new(server)
    end

    def self.auth_code
      @instance.auth_code
    end

    def initialize(server)
      super server

      @webrick_server = server
    end

    def do_GET(request, response)
      if request.path == "/oauth2callback"
        @auth_code = request.query["code"]

        if auth_code.nil?
          response.code = 500
          response.body "Unable to retrieve oauth code"
        else
          response.body = "OK"
        end
      end

      webrick_server.shutdown
    end
  end
end