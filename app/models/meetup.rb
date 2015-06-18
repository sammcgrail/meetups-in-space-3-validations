class Meetup < ActiveRecord::Base
  has_many :meetup_joins
  has_many :users, through: :meetup_joins
  has_many :comments

  validates :name, presence: true
  validates :location, presence: true
  validates :description, presence: true
end
