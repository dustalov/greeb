# encoding: utf-8

# It is possible to perform simple sentence detection that is based
# on Greeb's tokenization.
#
class Greeb::Segmentator
  # Sentence does not start from the separator charater, line break
  # character, and punctuation characters.
  #
  SENTENCE_DOESNT_START = [:separ, :break, :punct, :spunct]

  attr_reader :tokens

  # Create a new instance of {Greeb::Segmentator}.
  #
  # @param tokens [Array<Greeb::Entity>] tokens from [Greeb::Tokenizer].
  #
  def initialize tokens
    @tokens = tokens
  end

  # Sentences memoization method.
  #
  # @return [Array<Greeb::Entity>] a set of sentences.
  #
  def sentences
    detect_sentences! unless @sentences
    @sentences
  end

  # Subsentences memoization method.
  #
  # @return [Array<Greeb::Entity>] a set of subsentences.
  #
  def subsentences
    detect_subsentences! unless @subsentences
    @subsentences
  end

  # Extract tokens from the set of sentences.
  #
  # @param sentences [Array<Greeb::Entity>] a list of sentences.
  #
  # @return [Hash<Greeb::Entity, Array<Greeb::Entity>>] a hash with
  #   sentences as keys and tokens arrays as values.
  #
  def extract *sentences
    Hash[
      sentences.map do |s|
        [s, tokens.select { |t| t.from >= s.from and t.to <= s.to }]
      end
    ]
  end

  # Extract subsentences from the set of sentences.
  #
  # @param sentences [Array<Greeb::Entity>] a list of sentences.
  #
  # @return [Hash<Greeb::Entity, Array<Greeb::Entity>>] a hash with
  #   sentences as keys and subsentences arrays as values.
  #
  def subextract *sentences
    Hash[
      sentences.map do |s|
        [s, subsentences.select { |ss| ss.from >= s.from and ss.to <= s.to }]
      end
    ]
  end

  protected
  # Implementation of the sentence detection method. This method
  # changes the `@sentences` ivar.
  #
  # @return [nil] nothing.
  #
  def detect_sentences!
    @sentences = []

    rest = tokens.inject(new_sentence) do |sentence, token|
      if !sentence.from and SENTENCE_DOESNT_START.include?(token.type)
        next sentence
      end

      sentence.from = token.from unless sentence.from

      next sentence if sentence.to and sentence.to > token.to

      if :punct == token.type
        sentence.to = tokens.
          select { |t| t.from >= token.from }.
          inject(token) { |r, t| break r if t.type != token.type; t }.
          to

        @sentences << sentence
        sentence = new_sentence
      elsif :separ != token.type
        sentence.to = token.to
      end

      sentence
    end

    nil.tap { @sentences << rest if rest.from and rest.to }
  end

  # Implementation of the subsentence detection method. This method
  # changes the `@subsentences` ivar.
  #
  # @return [nil] nothing.
  #
  def detect_subsentences!
    @subsentences = SortedSet.new

    rest = tokens.inject(new_subsentence) do |subsentence, token|
      if !subsentence.from and SENTENCE_DOESNT_START.include?(token.type)
        next subsentence
      end

      subsentence.from = token.from unless subsentence.from

      next subsentence if subsentence.to and subsentence.to > token.to

      if [:punct, :spunct].include? token.type
        subsentence.to = tokens.
          select { |t| t.from >= token.from }.
          inject(token) { |r, t| break r if t.type != token.type; t }.
          to

        @subsentences << subsentence
        subsentence = new_subsentence
      elsif :separ != token.type
        subsentence.to = token.to
      end

      subsentence
    end

    nil.tap { @subsentences << rest if rest.from and rest.to }
  end

  private
  # Create a new instance of {Greeb::Entity} with `:sentence` type.
  #
  # @return [Greeb::Entity] a new entity instance.
  #
  def new_sentence
    Greeb::Entity.new(nil, nil, :sentence)
  end

  # Create a new instance of {Greeb::Entity} with `:subsentence` type.
  #
  # @return [Greeb::Entity] a new entity instance.
  #
  def new_subsentence
    Greeb::Entity.new(nil, nil, :subsentence)
  end
end
