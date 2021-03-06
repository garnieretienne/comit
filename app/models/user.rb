class User < ActiveRecord::Base
  has_many :blogs, dependent: :destroy

  attr_accessible :name

  # To activate open registration, uncomment the last part
  def self.from_omniauth(auth)
    where(auth.slice('provider', 'uid')).first #|| create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid      = auth['uid']
      user.name     = auth['info']['name']
    end
  end

end
