# This runtime error appears when {Greeb::Tokenizer} or
# {Greeb::Segmentator} tries to recognize unknown character.
#
class Greeb::UnknownEntity < RuntimeError
  attr_reader :text, :pos

  # @private
  def initialize(text, pos)
    @text, @pos = text, pos
  end

  # Generate the real error message.
  #
  def to_s
    'Could not recognize character "%s" @ %d' % [text[pos], pos]
  end
end
