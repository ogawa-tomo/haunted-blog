# frozen_string_literal: true

class Blog < ApplicationRecord
  belongs_to :user
  has_many :likings, dependent: :destroy
  has_many :liking_users, class_name: 'User', source: :user, through: :likings

  validates :title, :content, presence: true

  scope :published, -> { where('secret = FALSE') }

  scope :search, ->(term) { where('title LIKE ?', "%#{sanitize_sql_like(term || '')}%").or(where('content LIKE ?', "%#{sanitize_sql_like(term || '')}%")) }

  scope :default_order, -> { order(id: :desc) }

  scope :except_others_secret, ->(user) { where(secret: false).or(where(user: user)) }

  def owned_by?(target_user)
    user == target_user
  end
end
