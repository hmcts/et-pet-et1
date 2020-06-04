class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable

  belongs_to :claim, foreign_key: :reference, primary_key: :application_reference, required: true

  validates :password, presence: true
end
