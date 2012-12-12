class Blog < ActiveRecord::Base
  attr_accessible :git, :name, :path, :subdomain
  validates :git, :name, :path, :subdomain, presence: true
  validates :git, :path, :subdomain, uniqueness: true

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
      source = blob.data
      return Post.new(title: title, date: date, source: source)
    end
    return nil
  end

end
