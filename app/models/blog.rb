# frozen_string_literal: true

class Blog < ApplicationRecord
  belongs_to :user
  has_many :likings, dependent: :destroy
  has_many :liking_users, class_name: 'User', source: :user, through: :likings

  validates :title, :content, presence: true

  before_save :check_random_eyecatch_privilege

  scope :published, -> { where('secret = FALSE') }

  scope :search, ->(term) { where('title LIKE ?', "%#{sanitize_sql_like(term || '')}%").or(where('content LIKE ?', "%#{sanitize_sql_like(term || '')}%")) }

  scope :default_order, -> { order(id: :desc) }

  scope :published_or_users_own, ->(user) { published.or(where(user: user)) }

  def owned_by?(target_user)
    user == target_user
  end

  private

  def check_random_eyecatch_privilege
    self.random_eyecatch = false if random_eyecatch && !user.premium
  end
end
