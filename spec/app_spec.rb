require "rack/test"

require_relative "../app"
require_relative "../models/opinion"
require_relative "../services/debate_service"

describe "app" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe "post" do
    let(:request_data) { "{ \"url\": \"some_url\" }" }
    let(:url) { "some_url" }

    context "when there is an error" do
      before do
        allow(DebateService).to receive(:get_opinion).and_raise("error")
      end

      it "returns 400" do
        post '/', request_data
        expect(last_response.status).to eq(400)
      end
    end

    context "when there is no error" do
      let(:opinion) { instance_double(Opinion) }
      let(:opinion_json) { "{}" }

      before do 
        allow(opinion).to receive(:to_json).and_return(opinion_json)
        allow(DebateService).to receive(:get_opinion).and_return(opinion)
      end

      it "returns the opinion as json" do
        post '/', request_data
        expect(last_response.body).to eq(opinion_json.to_json)
      end
    end
  end
end