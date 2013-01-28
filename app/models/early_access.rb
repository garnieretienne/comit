class EarlyAccess < ActiveRecord::Base
  attr_accessible :email_address

  validates :email_address, email: true
  validates :email_address, uniqueness: {message: 'is already registered'}
end
