# encoding: utf-8

require 'set'

# Greeb's tokenization facilities. Use 'em with love.
#
class Greeb::Tokenizer
  # English and Russian letters.
  #
  LETTERS = /[A-Za-zА-Яа-яЁё]+/u

  # Floating point values.
  #
  FLOATS = /(\d+)[.,](\d+)/u

  # Integer values.
  #
  INTEGERS = /\d+/u

  # In-subsentence seprator (i.e.: "*" or "=").
  #
  SEPARATORS = /[*=_\/\\ ]+/u

  # Punctuation character (i.e.: "." or "!").
  #
  PUNCTUATIONS = /(\.|\!|\?)+/u

  # In-sentence punctuation character (i.e.: "," or "-").
  #
  SENTENCE_PUNCTUATIONS = /(\,|\[|\]|\(|\)|\-|:|;)+/u

  # Line breaks.
  #
  BREAKS = /\n+/u

  attr_reader :text, :scanner
  protected :scanner

  # Create a new instance of {Greeb::Tokenizer}.
  #
  # @param text [String] text to be tokenized.
  #
  def initialize(text)
    @text = text
  end

  # Tokens memoization method.
  #
  # @return [Set<Greeb::Entity>] a set of tokens.
  #
  def tokens
    tokenize! unless @tokens
    @tokens
  end

  protected
    # Perform the tokenization process. This method modifies
    # `@scanner` and `@tokens` instance variables.
    #
    # @return [nil] nothing unless exception is raised.
    #
    def tokenize!
      @scanner = Greeb::StringScanner.new(text)
      @tokens = SortedSet.new
      while !scanner.eos?
        parse! LETTERS, :letter or
        parse! FLOATS, :float or
        parse! INTEGERS, :integer or
        split_parse! SENTENCE_PUNCTUATIONS, :spunct or
        split_parse! PUNCTUATIONS, :punct or
        split_parse! SEPARATORS, :separ or
        split_parse! BREAKS, :break or
        raise @tokens.inspect
      end
    ensure
      scanner.terminate
    end

    # Try to parse one small piece of text that is covered by pattern
    # of necessary type.
    #
    # @param pattern [Regexp] a regular expression to extract the token.
    # @param type [Symbol] a symbol that represents the necessary token
    #   type.
    #
    # @return [Set<Greeb::Entity>] the modified set of extracted tokens.
    #
    def parse! pattern, type
      return false unless token = scanner.scan(pattern)
      position = scanner.char_pos
      @tokens << Greeb::Entity.new(position - token.length,
                                   position,
                                   type)
    end

    # Try to parse one small piece of text that is covered by pattern
    # of necessary type. This method performs grouping of the same
    # characters.
    #
    # @param pattern [Regexp] a regular expression to extract the token.
    # @param type [Symbol] a symbol that represents the necessary token
    #   type.
    #
    # @return [Set<Greeb::Entity>] the modified set of extracted tokens.
    #
    def split_parse! pattern, type
      return false unless token = scanner.scan(pattern)
      position = scanner.char_pos - token.length
      token.scan(/((.|\n)\2*)/).map(&:first).inject(position) do |before, s|
        @tokens << Greeb::Entity.new(before, before + s.length, type)
        before + s.length
      end
    end
end
