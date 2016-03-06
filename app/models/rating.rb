class Rating < ActiveRecord::Base
  include RatingAverage

  belongs_to :beer, touch: true
  belongs_to :user

  scope :recent, -> { where order("created_at desc").limit(3) }

  validates :score, numericality: { greater_than_or_equal_to: 1,
                                    less_than_or_equal_to: 50,
                                    only_integer: true }
  
  def to_s
    "#{self.beer.name} #{self.score}"
  end
end
