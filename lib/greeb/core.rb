# encoding: utf-8

# Greeb::Core is a simple tool that allows to invoke Greeb::Tokenizer and
# Greeb::Parser facilities together in a convinient and coherent way.
#
module Greeb::Core
  # Greeb::Core uses several helpers from Greeb::Parser to perform
  # additional analysis using there heuristic methods.
  #
  HELPERS = [:urls, :emails, :abbrevs]

  # Recognize e-mail addresses in the input text.
  #
  # @param text [String] input text.
  #
  # @return [Array<Greeb::Span>] a set of tokens.
  #
  def analyze(text, helpers = HELPERS)
    Greeb::Tokenizer.tokenize(text).tap do |tokens|
      helpers.each do |helper|
        Greeb::Parser.public_send(helper, text).each do |parsed|
          extract_tokens(tokens, parsed)
        end
      end
    end
  end

  alias_method :'[]', :analyze

  protected
  # Extact tokens of the specified type from the input tokens set.
  #
  # @param tokens [Array<Greeb::Span>] input tokens set.
  # @param entity [Greeb::Span] token to be extracted.
  #
  # @return [Greeb::Span] token to be extracted.
  #
  def extract_tokens(tokens, entity)
    from = tokens.index { |e| e.from == entity.from }
    to = tokens.index { |e| e.to == entity.to }
    tokens[from..to] = entity
  end
end

Greeb.send(:extend, Greeb::Core)
