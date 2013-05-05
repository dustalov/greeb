# encoding: utf-8

# Greeb's tokenization facilities. Use 'em with love. 
#
# Unicode character categories been obtained from
# <http://www.fileformat.info/info/unicode/category/index.htm>.
#
module Greeb::Tokenizer
  # http://www.youtube.com/watch?v=eF1lU-CrQfc
  extend self

  # English and Russian letters.
  #
  LETTERS = /[\p{L}]+/u

  # Floating point values.
  #
  FLOATS = /(\d+)[.,](\d+)/u

  # Integer values.
  #
  INTEGERS = /\d+/u

  # In-sentence punctuation character (i.e.: "," or "-").
  #
  SENTENCE_PUNCTUATIONS = /(\,|\-|:|;|\p{Ps}|\p{Pi}|\p{Pf}|\p{Pe})+/u

  # Punctuation character (i.e.: "." or "!").
  #
  PUNCTUATIONS = /[(\.|\!|\?)]+/u

  # In-subsentence seprator (i.e.: "*" or "=").
  #
  SEPARATORS = /[ \p{Nl}\p{No}\p{Pd}\p{Pc}\p{Po}\p{Sm}\p{So}\p{Sc}\p{Z}]+/u

  # Line breaks.
  #
  BREAKS = /(\r\n|\n|\r)+/u

  # Residuals.
  #
  RESIDUALS = /([\p{C}\p{M}\p{Sk}]|[\p{Nd}&&[^\d]])+/u

  # Perform the tokenization process.
  #
  # @return [Array<Greeb::Entity>] a set of tokens.
  #
  def tokenize text
    scanner = Greeb::StringScanner.new(text)
    tokens = []
    while !scanner.eos?
      step scanner, tokens or
      raise Greeb::UnknownEntity.new(text, scanner.char_pos)
    end
    tokens
  ensure
    scanner.terminate
  end

  protected
  # One iteration of the tokenization process.
  #
  # @param scanner [Greeb::StringScanner] string scanner.
  # @param tokens [Array<Greeb::Entity>] result array.
  #
  # @return [Array<Greeb::Entity>] the modified set of extracted tokens.
  #
  def step scanner, tokens
    parse! scanner, tokens, LETTERS, :letter or
    parse! scanner, tokens, FLOATS, :float or
    parse! scanner, tokens, INTEGERS, :integer or
    split_parse! scanner, tokens, SENTENCE_PUNCTUATIONS, :spunct or
    split_parse! scanner, tokens, PUNCTUATIONS, :punct or
    split_parse! scanner, tokens, SEPARATORS, :separ or
    split_parse! scanner, tokens, BREAKS, :break or
    parse! scanner, tokens, RESIDUALS, :residual
  end

  # Try to parse one small piece of text that is covered by pattern
  # of necessary type.
  #
  # @param scanner [Greeb::StringScanner] string scanner.
  # @param tokens [Array<Greeb::Entity>] result array.
  # @param pattern [Regexp] a regular expression to extract the token.
  # @param type [Symbol] a symbol that represents the necessary token
  #   type.
  #
  # @return [Array<Greeb::Entity>] the modified set of extracted tokens.
  #
  def parse! scanner, tokens, pattern, type
    return false unless token = scanner.scan(pattern)
    position = scanner.char_pos
    tokens << Greeb::Entity.new(position - token.length,
                                position,
                                type)
  end

  # Try to parse one small piece of text that is covered by pattern
  # of necessary type. This method performs grouping of the same
  # characters.
  #
  # @param scanner [Greeb::StringScanner] string scanner.
  # @param tokens [Array<Greeb::Entity>] result array.
  # @param pattern [Regexp] a regular expression to extract the token.
  # @param type [Symbol] a symbol that represents the necessary token
  #   type.
  #
  # @return [Array<Greeb::Entity>] the modified set of extracted tokens.
  #
  def split_parse! scanner, tokens, pattern, type
    return false unless token = scanner.scan(pattern)
    position = scanner.char_pos - token.length
    token.scan(/((.|\n)\2*)/).map(&:first).inject(position) do |before, s|
      tokens << Greeb::Entity.new(before, before + s.length, type)
      before + s.length
    end
  end
end
