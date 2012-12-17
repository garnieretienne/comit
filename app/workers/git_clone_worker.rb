class GitCloneWorker
  include Sidekiq::Worker

  def perform(url, path)
    git = Grit::Git.new('.')
    git.clone({}, url, path)
  end
end