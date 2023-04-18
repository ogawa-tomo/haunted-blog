# frozen_string_literal: true

class Blog < ApplicationRecord
  belongs_to :user
  has_many :likings, dependent: :destroy
  has_many :liking_users, class_name: 'User', source: :user, through: :likings

  validates :title, :content, presence: true

  validate :check_random_eyecatch_privilege

  scope :published, -> { where('secret = FALSE') }

  scope :search, lambda { |term|
    sanitized_term = sanitize_sql_like(term || '')
    where('title LIKE ?', "%#{sanitized_term}%").or(where('content LIKE ?', "%#{sanitized_term}%"))
  }

  scope :default_order, -> { order(id: :desc) }

  scope :published_or_owned_by, ->(user) { published.or(where(user: user)) }

  def owned_by?(target_user)
    user == target_user
  end

  private

  def check_random_eyecatch_privilege
    errors.add(:random_eyecatch, :unauthorized) if random_eyecatch && !user.premium
  end
end
