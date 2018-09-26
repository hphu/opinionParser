require_relative "../../models/argument"
require_relative "../../models/opinion"

describe Opinion do
  let(:author) { "author" }
  let(:title) { "This is my argument" }
  let(:opinion) { Opinion.new(title, author, 100, 0, []) }

  describe "arguments_breakdown" do
    context "when there are no arguments" do
      it "returns a hash of empty arguments" do
        breakdown = opinion.arguments_breakdown
        expect(breakdown[:yes]).to eq([])
        expect(breakdown[:no]).to eq([])
      end
    end

    context "when there are arguments" do
      let(:arg1) { Argument.new(false, nil, "No 1", nil) }
      let(:arg2) { Argument.new(true, nil, "Yes 1", nil) }
      let(:arg3) { Argument.new(false, nil, "No 2", nil) }
      let(:arg4) { Argument.new(true, nil, "Yes 2", nil) }

      let(:arguments) { [arg1, arg2, arg3, arg4] }

      before do
        opinion.arguments = arguments
      end

      it "calls to_json on each argument" do
        arguments.each do |arg|
          expect(arg).to receive(:to_json)
        end

        opinion.arguments_breakdown
      end

      it "separates the serialized arguments via agree" do
        breakdown = opinion.arguments_breakdown

        arguments.each do |arg|
          serialized = arg.to_json
          if arg.agree
            expect(breakdown[:yes]).to include(serialized)
            expect(breakdown[:no]).not_to include(serialized)
          else
            expect(breakdown[:no]).to include(serialized)
            expect(breakdown[:yes]).not_to include(serialized)
          end
        end
      end
    end
  end

  describe "to_json" do
    it "returns a hash with the correct keys" do
      result = opinion.to_json
      expect(result[:title]).to eq(opinion.title)
      expect(result[:author]).to eq(opinion.author)
      expect(result[:yes]).to eq(opinion.yes.to_s + "%")
      expect(result[:no]).to eq(opinion.no.to_s + "%")
    end

    it "serializes the arguments" do
      expected = "expected arguments"
      allow(opinion).to receive(:arguments_breakdown).and_return(expected)
      result = opinion.to_json

      expect(result[:arguments]).to eq(expected)
    end
  end
end