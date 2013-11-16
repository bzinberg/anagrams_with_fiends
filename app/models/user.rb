class User < ActiveRecord::Base

  validates :password_digest, confirmation: true, on: :create
  validates :username, presence: true, uniqueness: true
  belongs_to :table
  has_many :turns
  # Check if the username and password are valid
  def self.authenticate(username, password)
    user = find_by_username(username)
    if user && user.password == password
      user
    end
  end

  # Find all matches and partial matches of the username
  def self.search username
	   User.where("username like ?","%"+username.to_s+"%");
  end
end
