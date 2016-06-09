class Request < ActiveRecord::Base
  belongs_to :user, :foreign_key => 'request_id'
  
  attr_accessible :request_id, :approval_id, :user_id
  
end
