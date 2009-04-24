class Answer < ActiveRecord::Base
  
  
  belongs_to :user , :counter_cache => :total_answers
  belongs_to :question  , :counter_cache => true
  has_many :votes , :as => :voteable
  has_many :comments
  
  validates_presence_of :user , :question , :body
  
  after_create {|record| record.add_points(50)}
  
  
  # == InstanceMethods
  
  def select!
    if prev_selected = Answer.first(:conditions => {:question_id => self.question_id , :selected => true})
      prev_selected.toggle!(:selected)
    end
    self.toggle!(:selected)
    self.question.update_attribute(:answered , true)
    self.add_points(100)
    prev_selected
  end
  
  
  def add_points(points = 1)
    self.user.total_points += points
    self.user.save
  end
  
end
