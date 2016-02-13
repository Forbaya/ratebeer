module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    return 0 if ratings.count == 0
    ratings.inject(0) {|sum, x| sum + x.score} / ratings.count
  end
end
