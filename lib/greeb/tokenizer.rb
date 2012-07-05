# encoding: utf-8

require 'strscan'
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

  # Greeb operates with tokens, tuples of `<from, to, kind>`, where
  # `from` is a beginning of the token, `to` is an ending of the token,
  # and `kind` is a type of the token.
  #
  # There are several token types: `:letter`, `:float`, `:integer`,
  # `:separator`, `:punct` (for punctuation), `:spunct` (for in-sentence
  # punctuation), and `:break`.
  #
  Token = Struct.new(:from, :to, :kind)

  attr_reader :text, :tokens, :scanner
  protected :scanner

  # Create a new instance of {Tokenizer}.
  #
  # @param text [String] text to be tokenized.
  #
  def initialize(text)
    @text = text
    @tokens = Set.new

    tokenize!
  end

  protected
    # Perform the tokenization process. This method modifies
    # `@scanner` and `@tokens` instance variables.
    #
    # @return [nil] nothing unless exception is raised.
    #
    def tokenize!
      @scanner = StringScanner.new(text)
      while !scanner.eos?
        parse! LETTERS, :letter or
        parse! FLOATS, :float or
        parse! INTEGERS, :integer or
        split_parse! SENTENCE_PUNCTUATIONS, :spunct or
        split_parse! PUNCTUATIONS, :punct or
        split_parse! SEPARATORS, :separator or
        split_parse! BREAKS, :break or
        raise @tokens.inspect
      end
    ensure
      scanner.terminate
    end

    # Try to parse one small piece of text that is covered by pattern
    # of necessary kind.
    #
    # @param pattern [Regexp] a regular expression to extract the token.
    # @param kind [Symbol] a symbol that represents the necessary token
    # type.
    #
    # @return [Set<Token>] the modified set of extracted tokens.
    #
    def parse! pattern, kind
      return false unless token = scanner.scan(pattern)
      @tokens << Token.new(scanner.pos - token.length, scanner.pos, kind)
    end

    # Try to parse one small piece of text that is covered by pattern
    # of necessary kind. This method performs grouping of the same
    # characters.
    #
    # @param pattern [Regexp] a regular expression to extract the token.
    # @param kind [Symbol] a symbol that represents the necessary token
    # type.
    #
    # @return [Set<Token>] the modified set of extracted tokens.
    #
    def split_parse! pattern, kind
      return false unless token = scanner.scan(pattern)
      position = scanner.pos - token.length
      token.scan(/((.|\n)\2*)/).map(&:first).inject(position) do |before, s|
        @tokens << Token.new(before, before + s.length, kind)
        before + s.length
      end
    end
end
