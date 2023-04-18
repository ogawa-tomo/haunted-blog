# frozen_string_literal: true

require 'test_helper'

class BlogTest < ActiveSupport::TestCase
  test '通常ユーザーはアイキャッチを設定できない' do
    blog = blogs(:bob_blog)
    blog.random_eyecatch = true
    assert_not blog.valid?
  end
end
