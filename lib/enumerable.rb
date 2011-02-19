# encoding: utf-8

# Enumerable module additions.
#
module Enumerable
  def collect_with_index(i = -1) # :nodoc:
    collect { |e| yield(e, i += 1) }
  end
  alias map_with_index collect_with_index
end
