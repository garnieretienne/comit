class BlogFolderEraserWorker
  include Sidekiq::Worker

  def perform(path)
    if File.exist? path
      FileUtils.rm_rf path
    end
  end
end