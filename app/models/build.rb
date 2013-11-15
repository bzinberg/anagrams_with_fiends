class Build < Turn
  belongs_to :doer, class_name: 'User', foreign_key: 'doer_user_id'
end
