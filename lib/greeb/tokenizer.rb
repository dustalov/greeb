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

  Token = Struct.new(:from, :to, :kind)

  attr_reader :text, :tokens, :scanner
  protected :scanner

  def initialize(text)
    @text = text
    @tokens = Set.new

    tokenize!
  end

  protected
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

    def parse! pattern, kind
      return false unless token = scanner.scan(pattern)
      @tokens << Token.new(scanner.pos - token.length, scanner.pos, kind)
    end

    def split_parse! pattern, kind
      return false unless token = scanner.scan(pattern)
      position = scanner.pos - token.length
      token.scan(/((.|\n)\2*)/).map(&:first).inject(position) do |before, s|
        @tokens << Token.new(before, before + s.length, kind)
        before + s.length
      end
    end
end
