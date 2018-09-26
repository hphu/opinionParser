require "open-uri"

require_relative "../../services/debate_service"
require_relative "../../services/maps/opinion_map"
require_relative "../../models/opinion"

describe DebateService do
  describe "retrieve_opinion_data" do
    context "with an invalid domain" do
      let(:url) { "fake.com/opinion/thing" }

      it "raises an Invalid Domain error" do
        expect {
          DebateService.retrieve_opinion_data(url)
        }.to raise_error "Invalid Domain"
      end
    end

    context "with a valid domain" do
      let(:url) { "#{DebateService::DOMAIN}/opinion/thing" }

      it "calls open on the url" do
        allow(DebateService).to receive(:open).and_return("")
        expect(DebateService).to receive(:open).with(url)
        DebateService.retrieve_opinion_data(url)
      end

      context "when open raises an HTTP error" do
        let(:http_error) { OpenURI::HTTPError.new("404 Not Found.", nil) }

        before do
          allow(DebateService).to receive(:open).and_raise(http_error)
        end

        it "propagates the error" do
          expect {
            DebateService.retrieve_opinion_data(url)
          }.to raise_error http_error
        end
      end
    end
  end

  describe "get_opinion" do
    let(:url) { "#{DebateService::DOMAIN}/opinion/thing" }

    context "when retrieve_opinion_data raises an error" do
      let(:error) { "Random error" }

      before do
        allow(DebateService).to receive(:retrieve_opinion_data).and_raise(error)
      end

      it "propagates the error" do
        expect {
          DebateService.get_opinion(url)
        }.to raise_error error
      end
    end

    context "when retrieve_opinion_data is successful" do
      let(:data) { "mock response" }
      let(:opinion) { instance_double(Opinion) }
      let(:opinion_map) { instance_double(OpinionMap) }

      before do
        allow(DebateService).to receive(:retrieve_opinion_data).and_return(data)
      end

      it "returns an opinion via the opinion map" do
        expect(opinion_map).to receive(:opinion).and_return(opinion)
        expect(OpinionMap).to receive(:new).with(data).and_return(opinion_map)
        expect(DebateService.get_opinion(url)).to eq(opinion)
      end

    end
  end
end

