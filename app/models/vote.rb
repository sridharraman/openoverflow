class Vote < ActiveRecord::Base
  VOTE_RANGE = [-1 , 1]

  belongs_to :user , :counter_cache => :total_votes
  
  belongs_to :voteable , :polymorphic => true
  
  # == Validations
  validates_presence_of :vote , :voteable , :user
  validates_inclusion_of :vote, :in => VOTE_RANGE
  validates_uniqueness_of :user_id  , :scope => [:voteable_id , :voteable_type]
  
  # == Callbacks
  after_create {|record| record.vote_averages_of_voteables_on_create; record.add_points(10)}
  after_update {|record| record.vote_averages_of_voteables_on_update; record.add_points(-10)}
  
  
  
  def vote_averages_of_voteables_on_create
    self.voteable.votes_average += self.vote
    self.voteable.save
  end
  
  def vote_averages_of_voteables_on_update
    self.voteable.votes_average += self.vote * 2
    self.voteable.save
  end
  
  def add_points(points = 1)
    self.user.total_points += points
    self.user.save
  end
  
end
