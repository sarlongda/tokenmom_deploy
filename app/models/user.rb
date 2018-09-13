class User < ActiveRecord::Base
  has_many :messages
  validates :nick_name, :wallet_address, presence: true
end