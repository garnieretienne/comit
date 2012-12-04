class Blog < ActiveRecord::Base
  attr_accessible :git, :name, :path, :subdomain
  validates :git, :name, :path, :subdomain, presence: true
  validates :git, :path, :subdomain, uniqueness: true
end
