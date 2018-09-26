class Opinion
  attr_accessor :arguments, :author, :category, :no, :title, :yes

  def initialize(title, author, yes, no, arguments)
    self.arguments = arguments
    self.author = author
    self.no = no
    self.title = title
    self.yes = yes
  end

  def arguments_breakdown
    partitioned = arguments.partition(&:agree)
    {
      yes: partitioned[0].map(&:to_json),
      no: partitioned[1].map(&:to_json)
    }
  end

  def to_json
    {
      title: title,
      author: author,
      yes: "#{yes}%",
      no: "#{no}%",
      arguments: arguments_breakdown
    }
  end
end