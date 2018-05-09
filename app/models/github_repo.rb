class GithubRepo
  attr_reader :name, :url

  def initialize(attr)
    @name = attr["name"]
    @url = attr["html_url"]
  end
end
