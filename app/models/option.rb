class Option < ActiveRecord::Base
  belongs_to :poll

  def to_s
    self.text
  end
end
