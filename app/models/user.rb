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

  def is_member_of?(beer_club)
    clubs = BeerClub.all.select { |bc| not bc.members.find_by username:self.username }
    not clubs.include? beer_club
  end
  
  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?
    
    group = ratings.group_by { |x| x.beer.send(:style) }
    group.each_pair { |key, value| group[key] = value.sum(&:score) / value.size.to_f }
    group.sort_by { |key, value| value }.last[0]
  end

  def favorite_brewery
    return nil if ratings.empty?

    group = ratings.group_by { |x| x.beer.send(:brewery) }
    group.each_pair { |key, value| group[key] = value.sum(&:score) / value.size.to_f }
    group.sort_by { |key, value| value }.last[0]
  end
end
