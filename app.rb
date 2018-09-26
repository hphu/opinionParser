require "sinatra"
require "sinatra/contrib"
require_relative "services/debate_service"

get '/' do
  "Opinion parser"
end

post '/' do
  payload = JSON.parse(request.body.read.to_s, symbolize_names: true)
  url = payload[:url]

  begin
    opinion = DebateService.get_opinion(url)
  rescue => error
    halt 400, "Bad Request, #{error}"
  end
  json opinion.to_json
end