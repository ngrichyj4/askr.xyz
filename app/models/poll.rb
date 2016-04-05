class Poll < ActiveRecord::Base
  attr_accessor :params
  ALL_VOTING_STYLES = %w(choose_one choose_any sort)
  MAX_SLUG_LENGTH = 50

  # Associations
  ################
  has_many :options
  accepts_nested_attributes_for :options, 
    reject_if: proc { |attributes| attributes['text'].blank? }

  # Validations
  ###############
  validates_format_of :slug, with: /\A[a-zA-Z0-9_-]+\Z/, message: "can only be alphanumeric"
  validates :slug, length: { maximum: MAX_SLUG_LENGTH }
  validates_uniqueness_of :slug, message: "%{value} is already taken"
  validate :slug_does_not_end_with_whitespace # because validates_format_of ignores newlines at the end of the slug 
  validate :voting_style_in_permitted_list

  def voting_style_in_permitted_list
    errors.add(:voting_style, "is not included in #{ALL_VOTING_STYLES}") unless !voting_style || all_voting_styles.include?(voting_style)
  end

  def all_voting_styles
    # use a method so we can easily stub it in tests
    ALL_VOTING_STYLES
  end

  def slug_does_not_end_with_whitespace
    errors.add(:slug, "can only be alphanumeric") if slug && slug[-1] =~ /\W/
  end

  # Return sorted options by score
  def options_by_score
    self.options.sort{ |x, y| y.score <=> x.score }
  end

  # Return uniq number of voters
  def uniq_voters
    self.options.includes(:votes).pluck(:session_id).compact.uniq.length
  end

  # Score options in order
  def save_votes_with_score
    options_with_score = build_score_to_hash(self.params[:options].split(","))
    options_with_score.map {|id, score| 
      option = self.options.find_by(id: id)
      option.votes.create(score: score, session_id: self.params[:session_id])
    }
  end

  def save_votes
    vote_ids = self.params[:poll]
    vote_ids.map {|name, ids|
      ids.split.flatten.each do |id|
        option = self.options.find_by(id: id)
        option.votes.create(session_id: self.params[:session_id])
      end
    }
  end

  # Number of options -> max score, apply in descending order
  # [option_3, option_1, option_2] -> {option_3 => 3, option_1 => 2, option_2 => 1}
  def build_score_to_hash(options)
    score = 0; options.reverse.inject(Hash.new(0)) {|hash,id| hash[id] = (score+=1); hash }
  end

  # Defaults
  ############
  after_initialize :set_slug

  def set_slug
    unless self.slug
      self.slug = random_slug 
      attempts = 0
      max_attempts = 5
      while attempts < max_attempts && (self.class.pluck(:slug).include?(self.slug) || self.slug.length > MAX_SLUG_LENGTH)
        self.slug = random_slug
        attempts += 1
      end
      if attempts >= max_attempts
        self.slug = nil
      end
    end
  end

  private
  def random_slug
    slug = "#{RandomWord.adjs.next.titleize}#{RandomWord.nouns.next.titleize}"
    slug.gsub!(" ", "")
    slug
  end
end
