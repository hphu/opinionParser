require "open-uri"

require_relative "../models/argument"
require_relative "./maps/opinion_map"

class DebateService
  DOMAIN = "debate.org"

  class << self
    def get_opinion(url)
      web_response = retrieve_opinion_data(url)
      OpinionMap.new(web_response).opinion
    end

    def retrieve_opinion_data(url)
      begin
        raise "Invalid Domain" unless validate_domain(url)
        open(url)
      rescue OpenURI::HTTPError => error
        raise error
      end
    end

    def validate_domain(url)
      url.include?(DOMAIN)
    end
  end
end