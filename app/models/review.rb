class Review < ActiveRecord::Base
    belongs_to :post
    belongs_to :user
    
    attr_accessible :post_id, :review_text, :user_id
    
    validates_presence_of :review_text
    validates_length_of :review_text, :maximum => 130, :message => "Comment is too long (maximum is 130 characters)"
end
