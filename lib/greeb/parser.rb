# encoding: utf-8

require 'meta_array'
require 'enumerable'

# Graphematical Parser of the Greeb.
# Use it with love.
#
class Greeb::Parser
  # Russian lexeme (i.e.: "хуй").
  #
  RUSSIAN_LEXEME = /^[А-Яа-яЁё]+$/u

  # English lexeme (i.e.: "foo").
  #
  ENGLISH_LEXEME = /^[A-Za-z]+$/u

  # End of Line sequence (i.e.: "\n").
  #
  END_OF_LINE = /^\n+$/u

  # In-subsentence seprator (i.e.: "*" or "\").
  #
  SEPARATOR = /^[*=_\/\\ ]$/u

  # Punctuation character (i.e.: "." or "!").
  #
  PUNCTUATION = /^(\.|\!|\?)$/u

  # In-sentence punctuation character (i.e.: "," or "-").
  #
  SENTENCE_PUNCTUATION = /^(\,|\[|\]|\(|\)|\-|:|;)$/u

  # Digit (i.e.: "1337").
  #
  DIGIT = /^[0-9]+$/u

  # Digit-Letter complex (i.e.: "0xDEADBEEF").
  #
  DIGIT_LETTER = /^[А-Яа-яA-Za-z0-9Ёё]+$/u

  # Empty string (i.e.: "").
  #
  EMPTY = ''

  attr_accessor :text
  private :text=

  # Create a new instance of Greeb::Parser.
  #
  # ==== Parameters
  # text<String>:: Source text.
  #
  def initialize(text)
    self.text = text
  end

  # Perform the text parsing.
  #
  # ==== Returns
  # Array:: Tree of Graphematical Analysis of text.
  #
  def parse
    return @tree if @tree

    # parse tree
    tree = MetaArray.new

    # paragraph, sentence, subsentence
    p_id, s_id, ss_id = 0, 0, 0

    # current token
    token = ''

    # run FSM
    text.each_char do |c|
      case c
        when END_OF_LINE then begin
          case token
            when EMPTY then token << c
            when END_OF_LINE then begin
              token = ''
              p_id += 1
              s_id = 0
              ss_id = 0
            end
          else
            tree[p_id][s_id][ss_id] << token
            token = c
          end
        end
        when SEPARATOR then begin
          case token
            when EMPTY
          else
            tree[p_id][s_id][ss_id] << token
            while tree[p_id][s_id][ss_id].last == c
              tree[p_id][s_id][ss_id].pop
            end
            tree[p_id][s_id][ss_id] << c
            token = ''
          end
        end
        when PUNCTUATION then begin
          case token
            when EMPTY
          else
            tree[p_id][s_id][ss_id] << token
            tree[p_id][s_id][ss_id] << c
            token = ''
            s_id += 1
            ss_id = 0
          end
        end
        when SENTENCE_PUNCTUATION then begin
          case token
            when EMPTY
          else
            tree[p_id][s_id][ss_id] << token
            tree[p_id][s_id][ss_id] << c
            token = ''
            ss_id += 1
          end
        end
        when RUSSIAN_LEXEME then begin
          case token
            when END_OF_LINE then begin
              tree[p_id][s_id][ss_id] << ' '
              token = c
            end
          else
            token << c
          end
        end
        when ENGLISH_LEXEME then begin
          case token
            when END_OF_LINE then begin
              tree[p_id][s_id][ss_id] << ' '
              token = c
            end
          else
            token << c
          end
        end
        when DIGIT then begin
          case token
            when END_OF_LINE then begin
              tree[p_id][s_id][ss_id] << ' '
              token = c
            end
          else
            token << c
          end
        end
        when DIGIT_LETTER then begin
          case token
            when END_OF_LINE then begin
              tree[p_id][s_id][ss_id] << token
              token = c
            end
          else
            token << c
          end
        end
      end
    end

    unless token.empty?
      tree[p_id][s_id][ss_id] << token
    end

    tree.delete(nil)

    @tree = tree.to_a
  end
end
