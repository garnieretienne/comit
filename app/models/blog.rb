class Blog < ActiveRecord::Base
  attr_accessible :git, :name, :path, :subdomain
  validates :git, :name, :path, :subdomain, presence: true
  validates :git, :path, :subdomain, uniqueness: true

  def posts
    if !self.valid?
      return false
    end
    posts = []
    repo = Grit::Repo.new("#{Rails.root}/repositories/#{self.path}")
    last_commit = repo.commits.first
    if last_commit
      tree = last_commit.tree # Tree of last commit
      contents = tree.contents
      contents.each do |object|
        if object.class == Grit::Blob
          name  = /(?<year>\d\d\d\d)-(?<month>\d\d)-(?<day>\d\d)-(?<title>.*).md/.match(object.name)
          if name
            date   = Date.new name[:year].to_i, name[:month].to_i, name[:day].to_i
            title  = name[:title].gsub /_/, ' '
            source = object.data
            posts << Post.new(title: title, date: date, source: source)
          end
        end
      end
    end
    return posts
  end
end
