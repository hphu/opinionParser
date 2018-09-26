class Argument
  attr_accessor :author, :agree, :title, :text

  def initialize(agree, author, title, text)
    self.agree = agree
    self.author = author
    self.title = title
    self.text = text
  end

  def to_json
    {
      author: author,
      title: title,
      text: text
    }
  end
end