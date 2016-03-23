class Poll < ActiveRecord::Base
  ALL_VOTING_STYLES = %w(choose_one choose_any sort)

  validates_format_of :slug, with: /\A[a-zA-Z0-9_-]+\Z/, message: "can only be alphanumeric"
  validates :slug, length: { maximum: 50 }
  validate :slug_does_not_end_with_whitespace # because validates_format_of ignores newlines at the end of the slug 
  validate :voting_style_in_permitted_list

  def voting_style_in_permitted_list
    errors.add(:voting_style, "is not included in #{ALL_VOTING_STYLES}") unless all_voting_styles.include?(voting_style)
  end

  def all_voting_styles
    # use a method so we can easily stub it in tests
    ALL_VOTING_STYLES
  end

  def slug_does_not_end_with_whitespace
    errors.add(:slug, "can only be alphanumeric") if slug && slug[-1] =~ /\W/
  end
end
