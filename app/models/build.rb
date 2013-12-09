# Author: Ben

class Build < Turn
  belongs_to :doer, class_name: 'User', foreign_key: 'doer_user_id'
  validates_length_of :word, minimum: 3, maximum: 255
end
