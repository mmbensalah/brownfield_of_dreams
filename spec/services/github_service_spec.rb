require 'rails_helper'

describe 'Github API' do
  it 'exists' do
    user = create(:user, token: ENV["GITHUB_TOKEN"])
    service = GithubService.new(user.token)
    expect(service).to be_an_instance_of(GithubService)
  end

  it 'returns repository links associated with a user' do
    VCR.use_cassette("GithubService_repos") do
      user = create(:user, token: ENV["GITHUB_TOKEN"])
      service = GithubService.new(user.token)
      repo_list = service.get_repositories

      expect(repo_list.class).to eq(Array)
      expect(repo_list[0].keys).to include(:name)
      expect(repo_list[0].keys).to include(:url)
    end
  end
end
