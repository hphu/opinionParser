require "nokogiri"

require_relative "../../models/opinion"
require_relative "../../models/argument"

class OpinionMap
  attr_accessor :doc

  def initialize(response)
    self.doc = Nokogiri::HTML(response)
  end

  def opinion
    Opinion.new(
      title,
      author,
      yes_percentage,
      no_percentage,
      all_arguments
    )
  end

  def yes_percentage
    self.doc.css(".yes-text").text.to_i
  end

  def no_percentage
    self.doc.css(".no-text").text.to_i
  end

  def author
    self.doc.css(".tags > a").text
  end

  def category
    self.doc.css("#breadcrumb > a").last.text
  end

  def title
    self.doc.css(".q-title").first.text
  end

  def all_arguments
    arguments = []
    [true, false].each do |agreement|
      id_selector = agreement ? "#yes-arguments" : "#no-arguments"
      doc.css("#{id_selector} > ul > li.hasData").each do |argument_node|
        title = argument_node.css("h2").text
        text = argument_node.css("p").text
        author = argument_node.css("cite a").text
        arguments << Argument.new(agreement, author, title, text)
      end
    end
    arguments
  end

end