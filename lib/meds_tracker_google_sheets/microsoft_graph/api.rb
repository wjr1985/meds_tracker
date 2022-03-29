module MicrosoftGraph
  class API
    # From https://github.com/microsoftgraph/msgraph-training-rubyrailsapp/blob/main/demo/graph-tutorial/app/helpers/graph_helper.rb
    
    GRAPH_HOST = 'https://graph.microsoft.com'.freeze

    def make_api_call(method, endpoint, token, headers = nil, params = nil, payload = nil)
      headers ||= {}
      headers[:Authorization] = "Bearer #{token}"
      headers[:Accept] = 'application/json'

      params ||= {}

      case method.upcase
      when 'GET'
        HTTParty.get "#{GRAPH_HOST}#{endpoint}",
                     headers: headers,
                     query: params
      when 'POST'
        headers['Content-Type'] = 'application/json'
        HTTParty.post "#{GRAPH_HOST}#{endpoint}",
                      headers: headers,
                      query: params,
                      body: payload ? payload.to_json : nil
      else
        raise "HTTP method #{method.upcase} not implemented"
      end
    end
  end
end
