# frozen_string_literal: true

module BlogsHelper
  def format_content(blog)
    sanitize(blog.content.split("\n").map { |line| h(line) }.join('<br>'))
  end
end
