# encoding: utf-8

# It is often necessary to find different entities in a natural language
# text. These entities are URLs, e-mail addresses, names, etc. This module
# includes several helpers that could help to solve these problems.
#
module Greeb::Parser
  extend self

  # An URL pattern. Not so precise, but IDN-compatible.
  #
  URL = %r{\b(([\w-]+://?|www[.])[^\s()<>]+(?:\([\p{L}\w\d]+\)|([^.\s]|/)))}i

  # A horrible e-mail pattern.
  #
  EMAIL = /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i

  # Another horrible pattern. Now for abbreviations.
  #
  ABBREV = /\b((-{0,1}\p{L}\.)*|(-{0,1}\p{L}\. )*)-{0,1}\p{L}\./i

  # This pattern matches anything that looks like HTML. Or not.
  #
  HTML = /<(.*?)>/i

  # Time pattern.
  #
  TIME = /\b(\d|[0-2]\d):[0-6]\d(:[0-6]\d){0,1}\b/i

  # Apostrophe pattern.
  #
  APOSTROPHE = /['’]/i

  # Together pattern.
  #
  TOGETHER = [:letter, :integer, :apostrophe, :together]

  # Recognize URLs in the input text. Actually, URL is obsolete standard
  # and this code should be rewritten to use the URI concept.
  #
  # @param text [String] input text.
  #
  # @return [Array<Greeb::Span>] found URLs.
  #
  def urls(text)
    scan(text, URL, :url)
  end

  # Recognize e-mail addresses in the input text.
  #
  # @param text [String] input text.
  #
  # @return [Array<Greeb::Span>] found e-mail addresses.
  #
  def emails(text)
    scan(text, EMAIL, :email)
  end

  # Recognize abbreviations in the input text.
  #
  # @param text [String] input text.
  #
  # @return [Array<Greeb::Span>] found abbreviations.
  #
  def abbrevs(text)
    scan(text, ABBREV, :abbrev)
  end

  # Recognize HTML-alike entities in the input text.
  #
  # @param text [String] input text.
  #
  # @return [Array<Greeb::Span>] found HTML entities.
  #
  def html(text)
    scan(text, HTML, :html)
  end

  # Recognize timestamps in the input text.
  #
  # @param text [String] input text.
  #
  # @return [Array<Greeb::Span>] found HTML entities.
  #
  def time(text)
    scan(text, TIME, :time)
  end

  # Retrieve apostrophes from the tokenized text. The algorithm may be
  # more optimal.
  #
  # @param text [String] input text.
  # @param spans [Array<Greeb::Span>] already tokenized text.
  #
  # @return [Array<Greeb::Span>] retrieved apostrophes.
  #
  def apostrophes(text, spans)
    apostrophes = scan(text, APOSTROPHE, :apostrophe)
    return [] if apostrophes.empty?

    apostrophes.each { |s| Greeb.extract_spans(spans, s) }.clear

    spans.each_with_index.each_cons(3).reverse_each do |(s1, i), (s2, j), (s3, k)|
      next unless s1 && s1.type == :letter
      next unless s2 && s2.type == :apostrophe
      next unless !s3 || s3 && s3.type == :letter
      s3, k = s2, j unless s3
      apostrophes << Greeb::Span.new(s1.from, s3.to, s1.type)
      spans[i..k] = apostrophes.last
    end

    apostrophes
  end

  # Merge some spans that are together.
  #
  # @param spans [Array<Greeb::Span>] already tokenized text.
  #
  # @return [Array<Greeb::Span>] merged spans.
  #
  def together(spans)
    loop do
      converged = true

      spans.each_with_index.each_cons(2).reverse_each do |(s1, i), (s2, j)|
        next unless TOGETHER.include?(s1.type) && TOGETHER.include?(s2.type)
        spans[i..j] = Greeb::Span.new(s1.from, s2.to, :together)
        converged = false
      end

      break if converged
    end

    spans
  end

  private
  # Implementation of regexp-based {Greeb::Span} scanner.
  #
  # @param text [String] input text.
  # @param regexp [Regexp] regular expression to be used.
  # @param type [Symbol] type field for the new {Greeb::Span} instances.
  # @param offset [Fixnum] offset of the next match.
  #
  # @return [Array<Greeb::Span>] found entities.
  #
  def scan(text, regexp, type, offset = 0)
    Array.new.tap do |matches|
      while text and md = text.match(regexp)
        start, stop = md.offset(0)
        matches << Greeb::Span.new(offset + start, offset + stop, type)
        text, offset = text[stop..-1], offset + stop
      end
    end
  end
end
