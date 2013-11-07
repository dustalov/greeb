# Greeb operates with spans. A span is a tuple of *(from, to, kind)*, where
# *from* is a beginning of the span, *to* is an ending of the span,
# and *kind* is a type of the span.
#
# There are several span types: `:letter` for letters, `:float` for
# floating point decimals, `:integer` for numbers, `:separ` for separators,
# `:punct` for punctuation characters, `:spunct` for in-sentence punctuation
# characters, `:space` for spaces, and `:break` for line endings.
#
class Greeb::Span < Struct.new(:from, :to, :type)
  # Create a deriviative structure that is based on Greeb::Span
  # members. Useful in integrating with Greeb.
  #
  # @param members [Array<Symbol>] additional members.
  #
  # @return [Struct] a new structure.
  #
  def self.derivate(*members)
    Struct.new(*self.members, *members)
  end

  # Select the slice of the given text using coorinates of this span.
  #
  # @param text [String] a text to be extracted.
  #
  # @return [String] the retrieved substring.
  #
  def slice(text)
    text[from...to]
  end

  # @private
  def <=> other
    if (comparison = self.from <=> other.from) == 0
      self.to <=> other.to
    else
      comparison
    end
  end

  # @private
  def eql? other
    return false unless type == other.type
    (self <=> other) == 0
  end
end
