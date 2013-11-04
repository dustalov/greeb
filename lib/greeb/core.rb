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
          extract_spans(tokens, parsed)
        end
      end
    end
  end

  alias_method :'[]', :analyze

  protected
  # Extact spans of the specified type from the input spans set.
  #
  # @param spans [Array<Greeb::Span>] input spans set.
  # @param span [Greeb::Span] span to be extracted.
  #
  # @return [Greeb::Span] span to be extracted.
  #
  def extract_spans(spans, span)
    from = spans.index { |e| e.from == span.from }
    to = spans.index { |e| e.to == span.to }
    return unless from && to
    spans[from..to] = span
  end
end

Greeb.send(:extend, Greeb::Core)
