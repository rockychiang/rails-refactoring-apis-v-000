class GithubService
  attr_reader :access_token, :username

  def initialize(attr=nil)
    @access_token = attr["access_token"] if !!attr
  end

  def authenticate!(github_client, github_secret, code)
    resp = Faraday.post("https://github.com/login/oauth/access_token") do |req|
      req.body = { client_id: github_client, client_secret: github_secret, code: code }
      req.headers['Accept'] = 'application/json'
    end

    @access_token = JSON.parse(resp.body)["access_token"]
  end

  def get_username
    resp = Faraday.get("https://api.github.com/user") do |req|
      req.headers['Authorization'] = "token #{@access_token}"
      req.headers['Accept'] = 'application/json'
    end

    JSON.parse(resp.body)["login"]
  end

  def get_repos
    resp = Faraday.get "https://api.github.com/user/repos", {}, {'Authorization' => "token #{@access_token}", 'Accept' => 'application/json'}
    JSON.parse(resp.body).map{|repo| GithubRepo.new(repo)}
  end

  def create_repo(name)
    response = Faraday.post "https://api.github.com/user/repos", {name: name}.to_json, {'Authorization' => "token #{@access_token}", 'Accept' => 'application/json'}
  end

end
