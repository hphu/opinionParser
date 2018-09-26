require_relative "../../../models/argument"
require_relative "../../../models/opinion"
require_relative "../../../services/maps/opinion_map"

describe OpinionMap do
  let(:empty_arguments) do 
    File.read(
      File.dirname(__FILE__) + "/__fixtures__/empty_arguments.html"
    )
  end
  
  let(:yes_and_no_arguments) do
    File.read(
      File.dirname(__FILE__) + "/__fixtures__/yes_and_no_arguments.html"
    )
  end

  let(:no_argument) do
    File.read(
      File.dirname(__FILE__) + "/__fixtures__/no_argument.html"
    )
  end

  context "when there 0 arguments" do
    let(:opinionMap) { OpinionMap.new(empty_arguments) }

    it "returns 0 for yes_percentage" do
      expect(opinionMap.yes_percentage).to eq(0)
    end

    it "returns 0 for no_percentage" do
      expect(opinionMap.no_percentage).to eq(0)
    end

    it "parses the correct author" do
      expect(opinionMap.author).to eq("")
    end

    it "parses the correct category" do
      expect(opinionMap.category).to eq("Cars")
    end

    it "parses the correct title" do
      expect(opinionMap.title).to eq("Are racing cars and bikes are the cause for death")
    end

    it "returns an empty arguments list" do
      expect(opinionMap.all_arguments).to eq([])
    end
  end

  context "when there are only no arguments" do
    let(:opinionMap) { OpinionMap.new(no_argument) }

    it "returns 100 for yes_percentage" do
      expect(opinionMap.yes_percentage).to eq(0)
    end

    it "returns 0 for no_percentage" do
      expect(opinionMap.no_percentage).to eq(100)
    end

    it "parses the correct author" do
      expect(opinionMap.author).to eq("driscoll")
    end

    it "parses the correct category" do
      expect(opinionMap.category).to eq("People")
    end

    it "parses the correct title" do
      expect(opinionMap.title).to eq("Quantum physics has nothing to do with women.")
    end

    it "creates and returns the correct arguments" do
      expected = "argument"
      expect(Argument).to receive(:new).with(
        false,
        "Forthelulz",
        "Quantum physics has everything to do with everything.",
        "Let's see here. . . Quantum physics largely boils down to \"life, The universe, And everything\". From wikipedia: \"Quantum mechanics (QM; also known as quantum physics, Quantum theory, The wave mechanical model, Or matrix mechanics), Including quantum field theory, Is a fundamental theory in physics which describes nature at the smallest scales of energy levels of atoms and subatomic particles. \"Being as women (and indeed all observable existence) would be affected by this, Quantum physics does has the same something to do with women as they do to the rest of existence. Make of that what you will."
      ).and_return(expected)
      expect(opinionMap.all_arguments).to eq([expected])
    end
  end

    context "when there are both yes and no arguments" do
    let(:opinionMap) { OpinionMap.new(yes_and_no_arguments) }

    it "returns the correct yes_percentage" do
      expect(opinionMap.yes_percentage).to eq(33)
    end

    it "returns the correct for no_percentage" do
      expect(opinionMap.no_percentage).to eq(67)
    end

    it "parses the correct author" do
      expect(opinionMap.author).to eq("")
    end

    it "parses the correct category" do
      expect(opinionMap.category).to eq("People")
    end

    it "parses the correct title" do
      expect(opinionMap.title).to eq("Is pda in schools a bad thing?")
    end

    it "creates and returns the correct arguments" do
      expected_args = ["argument1", "argument2", "argument3"]
      expect(Argument).to receive(:new).with(
        true,
        "MitchV",
        "Depending on factors.",
        "There are times and places we expect students to have some kind of displays of affection such as at school dances/proms. Thing is, Even under those circumstances, Some types such as making out should be discouraged. I could see if your a teen who is in a relationship with someone, It may be okay for them to hold hands an occasionally kiss but things like prolonged embraces or french kissing should be discouraged. I doubt anyone has issues with little kids sharing affection as it means something different to them as opposed to teens. Thing is, Teens are still developing. Not just physically but emotionally. This means they still lack the maturity fully understand romantic relationships. Funny thing is, They tend to think that doing thing makes them more mature where it actually shows their lack of self control so makes them seem more immature."
      ).and_return(expected_args[0])

      expect(Argument).to receive(:new).with(
        false,
        "",
        "No, Of course not!",
        "Come on, Teachers. Really? Unless two kids are doing something actually inappropriate, I seriously doubt it's logical to ban hugs and kisses. It's just showing that they care, And it's much better than kids fighting or something annoying like that. Besides, If its to prevent crushes or something, That'll happen regardless."
      ).and_return(expected_args[1])

      expect(Argument).to receive(:new).with(
        false,
        "linabug200",
        "Its not bad",
        "It teaches our kids that pda is a negative thing when really, Its foundation for relationships. Im not saying sexual pda is ok in school, But innocent hand holding? Come on guys if u don't like it then don't look at it. I want to hear yalls opinions and how yall feel."
      ).and_return(expected_args[2])
      expect(opinionMap.all_arguments).to eq(expected_args)
    end

    context "opinion" do
      it "returns a new opinion with the correct arguments" do 
        expected = "mock opinion"

        allow(opinionMap).to receive(:all_arguments).and_return(['arg'])

        expect(Opinion).to receive(:new).with(
          opinionMap.title,
          opinionMap.author,
          opinionMap.yes_percentage,
          opinionMap.no_percentage,
          opinionMap.all_arguments
        ).and_return(expected)

        expect(opinionMap.opinion).to eq(expected)
      end
    end
  end
end
