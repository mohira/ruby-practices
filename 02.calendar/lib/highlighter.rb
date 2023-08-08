# frozen_string_literal: true

class TodayHighlighter
  def do(str)
    "\033[7m#{str}\033[0m"
  end
end

class NilHighlighter
  def do(str)
    str
  end
end
