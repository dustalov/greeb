# encoding: utf-8

require 'strscan'

# {StringScanner} provides for lexical scanning operations on a String.
# This implementation covers the byte slicing problem in the standard
# library's implementation.
#
class Greeb::StringScanner < StringScanner
  # Returns the character position of the scan pointer. In the `reset`
  # position, this value is zero. In the `terminated` position
  # (i.e. the string is exhausted), this value is the length
  # of the string.
  #
  # @return [Fixnum] the character position of the scan pointer.
  #
  def char_pos
    string.byteslice(0...pos).length
  end
end
