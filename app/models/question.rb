class Question < ActiveRecord::Base
  has_many :answers
  belongs_to :user

  validates :title, presence: true, length: { minimum: 40 }
  validates :body, presence: true, length: { minimum: 150 }
  validates :user_id, presence: true
end
