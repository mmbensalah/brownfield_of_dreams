class User < ApplicationRecord
  has_many :user_videos
  has_many :videos, through: :user_videos
  has_many :friendships
  has_many :friends, through: :friendships

  has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id"
  has_many :inverse_friends, through: :inverse_friendships, source: :user

  validates :email, uniqueness: true, presence: true
  validates_presence_of :password, on: :create
  validates_presence_of :first_name
  enum role: [:default, :admin]
  has_secure_password

  def github_connect(auth)
    self.uid   = auth["uid"]
    self.token = auth["credentials"]["token"]
    self.save
  end

  def self.uid_lookup(github_user)
    find_by(uid: github_user.uid)
  end

  def list_ordered_videos
    UserVideo.where(user_id: self.id)
    .joins(:video)
    .order('videos.tutorial_id asc', 'videos.position asc')
    .pluck(:title)
  end

end
