require_relative "../../models/argument"

describe Argument do
  let(:agree) { false }
  let(:author) { "author" }
  let(:title) { "This is my argument" }
  let(:text) { "Because of these reasons" }
  let(:argument) { Argument.new(agree, author, title, text) }

  context "to_json" do
    it "returns a hash with the correct keys" do
      result = argument.to_json
      expect(result).to be_a(Hash)
      expect(result[:author]).to equal(author)
      expect(result[:title]).to equal(title)
      expect(result[:text]).to equal(text)
    end

    it "does not include agree" do
      result = argument.to_json
      expect(result.has_key? :agree).to be(false)
    end
  end
end