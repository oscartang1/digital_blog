class Post < ActiveRecord::Base
  acts_as_likeable
  
  has_attached_file :photo,
                    :styles => { :full => "500x500>", :medium => "500x500#", :thumb => "70x70#" }, 
                    :default_url => "/assets/posts/:id/:style/:basename.:extension"
                    
  has_many :reviews, order: 'created_at desc '
  belongs_to :user
  
  attr_accessible :text, :id, :photo

  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png'] 
  
  validate :any_present?

  def any_present?
    if text.blank? and photo.blank?
        errors.add :base, "Cannot make an empty post"
    end
  end
  

end
