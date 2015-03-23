class User < ActiveRecord::Base
  has_many :questions
  has_many :answers

  validates :name, presence: true
end
