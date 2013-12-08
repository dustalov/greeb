# encoding: utf-8

# It is possible to perform simple sentence detection that is based
# on Greeb's tokenization.
#
class Greeb::Segmentator
  # Sentence does not start from the separator charater, line break
  # character, punctuation characters, and spaces.
  #
  SENTENCE_AINT_START = [:separ, :break, :punct, :spunct, :space]

  attr_reader :tokens

  # Create a new instance of {Greeb::Segmentator}.
  #
  # @param tokens [Array<Greeb::Span>] tokens from [Greeb::Tokenizer].
  #
  def initialize(tokens)
    @tokens = tokens
  end

  # Sentences memoization method.
  #
  # @return [Array<Greeb::Span>] a set of sentences.
  #
  def sentences
    @sentences ||= detect_spans(new_sentence, [:punct])
  end

  # Subsentences memoization method.
  #
  # @return [Array<Greeb::Span>] a set of subsentences.
  #
  def subsentences
    @subsentences ||= detect_spans(new_subsentence, [:punct, :spunct])
  end

  # Extract tokens from the set of sentences.
  #
  # @param sentences [Array<Greeb::Span>] a list of sentences.
  #
  # @return [Array<Greeb::Span, Array<Greeb::Span>>] a hash with
  #   sentences as keys and tokens arrays as values.
  #
  def extract(sentences, collection = tokens)
    sentences.map do |s|
      [s, collection.select { |t| t.from >= s.from and t.to <= s.to }]
    end
  end

  protected
  # Implementation of the span detection method.
  #
  # @param sample [Greeb::Span] a sample of span to be cloned in the
  # process.
  # @param stop_marks [Array<Symbol>] an array that stores the
  # correspondent stop marks of the necessary spans.
  # @param collection [Array<Greeb::Span>] an initial set of spans
  # to be populated.
  #
  # @return [Array<Greeb::Span>] a modified collection.
  #
  def detect_spans(sample, stop_marks, collection = [])
    rest = tokens.inject(sample.dup) do |span, token|
      next span if sentence_aint_start? span, token
      span.from = token.from unless span.from
      next span if span.to and span.to > token.to

      if stop_marks.include? token.type
        span.to = find_forward(tokens, token).to
        collection << span
        span = sample.dup
      elsif ![:separ, :space].include? token.type
        span.to = token.to
      end

      span
    end

    if rest.from && rest.to
      collection << rest
    else
      collection
    end
  end

  private
  # Check the possibility of starting a new sentence by the specified
  # pair of span and token.
  #
  # @param span [Greeb::Span] an span to be checked.
  # @param token [Greeb::Span] an token to be checked.
  #
  # @return true or false.
  #
  def sentence_aint_start?(span, token)
    !span.from and SENTENCE_AINT_START.include? token.type
  end

  # Find a forwarding token that has another type.
  #
  # @param collection [Array<Greeb::Span>] array of possible tokens.
  # @param sample [Greeb::Span] a token that is treated as a sample.
  #
  # @return [Greeb::Span] a forwarding token.
  #
  def find_forward(collection, sample)
    collection.select { |t| t.from >= sample.from }.
      inject(sample) { |r, t| t.type == sample.type ? t : (break r) }
  end

  # Create a new instance of {Greeb::Span} with `:sentence` type.
  #
  # @return [Greeb::Span] a new span instance.
  #
  def new_sentence
    Greeb::Span.new(nil, nil, :sentence)
  end

  # Create a new instance of {Greeb::Span} with `:subsentence` type.
  #
  # @return [Greeb::Span] a new span instance.
  #
  def new_subsentence
    Greeb::Span.new(nil, nil, :subsentence)
  end
end
