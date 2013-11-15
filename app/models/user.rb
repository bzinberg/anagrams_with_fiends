class User < ActiveRecord::Base
  belongs_to :table
  has_many :turns

end
