class Follow < ActiveRecord::Base
  belongs_to :user, :foreign_key => 'follower_id'
  
  attr_accessible :followable_id, :followable_type
  
  extend ActsAsFollower::FollowerLib
  extend ActsAsFollower::FollowScopes

  # NOTE: Follows belong to the "followable" interface, and also to followers
  belongs_to :followable, :polymorphic => true
  belongs_to :follower,   :polymorphic => true

  def block!
    self.update_attribute(:blocked, true)
  end

end
