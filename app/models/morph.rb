# Author: Ben

class Morph < Turn
  belongs_to :changed_turn, class_name: 'Turn', foreign_key: 'changed_turn_id'
  belongs_to :doer, class_name: 'User', foreign_key: 'doer_user_id'
  validates_length_of :word, maximum: 255
end
