class MeetupJoin < ActiveRecord::Base
  belongs_to :user
  belongs_to :meetup

  validates :user, presence: true
  validates :meetup, presence: true
  validates_uniqueness_of :user_id, :scope => :meetup_id
end
