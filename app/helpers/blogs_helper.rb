# frozen_string_literal: true

module BlogsHelper
  def format_content(blog)
    ActiveSupport::SafeBuffer.new(blog.content.split("\n").map { |line| h(line) }.join('<br>'))
  end
end
