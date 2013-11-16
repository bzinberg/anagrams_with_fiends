class User < ActiveRecord::Base

  has_secure_password
  validates :username, presence: true, uniqueness: true
  belongs_to :table
  has_many :turns
  # Find all matches and partial matches of the username
  def self.search username
	   User.where("username like ?","%"+username.to_s+"%");
  end
end
