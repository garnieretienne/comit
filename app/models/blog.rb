class Blog < ActiveRecord::Base
  belongs_to :user
  attr_accessible :git, :name, :subdomain
  
  validates :git, :name, :subdomain, :token, :user_id, presence: true
  validates :git, :subdomain, :path, :token, uniqueness: true
  validates :git, git_url: true


  before_validation :downcase_subdomain, :generate_token
  before_create     :generate_path!
  after_create      :clone_blog_repo
  before_update     :update_path_if_needed
  after_update      :clone_blog_repo_if_needed
  before_destroy    :erase_blog_folder

  def posts
    posts = []
    if self.valid?
      tree = git_tree
      if tree
        blobs = tree.blobs
        blobs.each do |object|
          post = get_post object
          if post then posts << post end
        end
      end
    end
    return posts.reverse!
  end

  def find_post(filename)
    tree = git_tree
    if tree
      object = tree / filename
      if object
        if object.class == Grit::Blob
          return get_post object
        end
      end
    end
    return nil
  end

  def refresh
    if File.exist? "#{Rails.root}/repositories/#{self.path}"
      repo = Grit::Repo.new("#{Rails.root}/repositories/#{self.path}")
      process = repo.git.pull({:process_info => true}, 'origin', 'master')
      if process[0] != 0
        logger.error "  Blog refresh error: #{process[2]}"
        return false
      else
        return true
      end
    else
      return false
    end
  end

  def ready?
    if self.valid?
      File.exist?("#{Rails.root}/repositories/#{self.path}")
    else
      return false
    end
  end

  private

  # Return the root tree of the Git repository (from the last commit on the master branch).
  def git_tree
    repo = Grit::Repo.new("#{Rails.root}/repositories/#{self.path}")
    last_commit = repo.commits.first
    if last_commit
      return last_commit.tree
    else
      return nil
    end
  end

  # Build a post object using a blob git object. 
  def get_post(blob)
    name  = /(?<year>\d\d\d\d)-(?<month>0[0-9]|1[0-2])-(?<day>[0-2][0-9]|3[01])-(?<title>\S*).(md|markdown)/.match(blob.name)
    if name
      begin
        date = Date.new name[:year].to_i, name[:month].to_i, name[:day].to_i
      rescue
        return nil
      end
      title  = name[:title].gsub /_/, ' '
      source = blob.data.force_encoding("UTF-8")
      history, authors = get_post_history blob
      return Post.new(title: title, date: date, source: source, authors: authors, history: history)
    end
    return nil
  end

  # Retrace post history (using commit authors)
  # and find post authors.
  def get_post_history(blob)
    history = []
    authors = []
    repo = Grit::Repo.new("#{Rails.root}/repositories/#{self.path}")
    commits = repo.log('master', blob.basename)
    commits.each do |commit|
      date = commit.date
      author = Grit::Actor.from_string(commit.author_string)
      authorHash = {name: author.name, email: author.email}
      authors << authorHash if !authors.include? authorHash
      if commit.sha == commits.last.sha then
        history << "created #{date.strftime("on %m-%d-%Y at %H:%M")} by #{author.name} (#{commit.message})"
      else
        history << "updated #{date.strftime("on %m-%d-%Y at %H:%M")} by #{author.name} (#{commit.message})"
      end
    end
    return history.reverse, authors.reverse
  end

  # Ensure all subdomains are downcased
  def downcase_subdomain
    self.subdomain = self.subdomain.downcase if self.subdomain
  end

  # Generate a unique path using timestamp and Git URL basename
  def generate_path!
    self.path = "#{Time.new.to_i}_#{File.basename(self.git)}"
  end

  # Generate a unique token used to refresh the git repo
  def generate_token
    self.token ||= SecureRandom.urlsafe_base64
  end

  # Delete the blog folder
  def erase_blog_folder
    BlogFolderEraserWorker.perform_async("#{Rails.root}/repositories/#{self.path}")
  end

  # Clone the blog repo
  def clone_blog_repo
    GitCloneWorker.perform_async(self.git, "#{Rails.root}/repositories/#{self.path}")
  end

  # If git address has been modified, erase old folder and generate 
  # a new path from the new git address.
  def update_path_if_needed
    if self.changed_attributes["git"]
      erase_blog_folder
      generate_path!
    end
  end

  # If git address has been modified, clone the new repo 
  # into corresponding path.
  def clone_blog_repo_if_needed
    if self.changed_attributes["git"]
      clone_blog_repo
    end
  end

end
