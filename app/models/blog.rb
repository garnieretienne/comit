class Blog < ActiveRecord::Base
  belongs_to :user
  attr_accessible :git, :name, :subdomain
  validates :git, :name, :subdomain, :user_id, presence: true
  validates :git, :subdomain, uniqueness: true
  validates :git, git_url: true

  before_save :generate_path, :generate_token
  before_validation :downcase_subdomain

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
    repo = Grit::Repo.new("#{Rails.root}/repositories/#{self.path}")
    process = repo.git.pull({:process_info => true}, 'origin', 'master')
    if process[0] != 0
      logger.error "  Blog refresh error: #{process[2]}"
      return false
    else
      return true
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
      return Post.new(title: title, date: date, source: source)
    end
    return nil
  end

  # Generate a unique path using timestamp and Git URL basename
  def generate_path
    self.path = "#{Time.new.to_i}_#{File.basename(self.git)}"
  end

  # Generate a unique token used to refresh the git repo
  def generate_token
    self.token ||= SecureRandom.urlsafe_base64
  end

  # Ensure all subdomains are downcased
  def downcase_subdomain
    self.subdomain = self.subdomain.downcase if self.subdomain
  end

end
