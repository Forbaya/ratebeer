class User < ActiveRecord::Base
  include RatingAverage

  validates :username, uniqueness: true,
                       length: { minimum: 3,
                                 maximum: 15 }
  validates :password, length: { minimum: 4 },
                       format: {
                         with: /\d.*[A-Z]|[A-Z].*\d/,
                         message: "password has to contain one number and one upper case letter"
                       }
  
  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  has_secure_password

  def self.top_raters(n)
    User.all.sort_by { |u| -u.ratings.count }.first(3)
  end
  
  def is_member_of?(beer_club)
    clubs = BeerClub.all.select { |bc| not bc.members.find_by username:self.username }
    not clubs.include? beer_club
  end
  
  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    favorite :style
  end

  def favorite_brewery
    favorite :brewery
  end

  def favorite(category)
    return nil if ratings.empty?

    rated = ratings.map{ |r| r.beer.send(category) }.uniq
    rated.sort_by { |item| -rating_of(category, item) }.first
  end
  
  def rating_of(category, item)
    ratings_of = ratings.select{ |r| r.beer.send(category)==item }
    ratings_of.map(&:score).inject(&:+) / ratings_of.count.to_f
  end
end
