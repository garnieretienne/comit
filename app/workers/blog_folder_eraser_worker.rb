class BlogFolderEraserWorker
  include Sidekiq::Worker

  def perform(path)
    FileUtils.rm_rf path
  end
end