class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :meetup

  validates :body, presence: true
end
