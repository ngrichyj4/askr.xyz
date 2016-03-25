class Option < ActiveRecord::Base
  belongs_to :poll
  has_many :votes
 
  def to_s
    self.text
  end

  def score
  	self.votes.pluck(:score).reduce(:+).to_i
  end
end
