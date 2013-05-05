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
  def initialize(tokens)
    @tokens = tokens
  end

  # Sentences memoization method.
  #
  # @return [Array<Greeb::Entity>] a set of sentences.
  #
  def sentences
    @sentences ||= detect_entities(new_sentence, [:punct])
  end

  # Subsentences memoization method.
  #
  # @return [Array<Greeb::Entity>] a set of subsentences.
  #
  def subsentences
    @subsentences ||= detect_entities(new_subsentence, [:punct, :spunct])
  end

  # Extract tokens from the set of sentences.
  #
  # @param sentences [Array<Greeb::Entity>] a list of sentences.
  #
  # @return [Hash<Greeb::Entity, Array<Greeb::Entity>>] a hash with
  #   sentences as keys and tokens arrays as values.
  #
  def extract(sentences, collection = tokens)
    Hash[
      sentences.map do |s|
        [s, collection.select { |t| t.from >= s.from and t.to <= s.to }]
      end
    ]
  end

  protected
  # Implementation of the entity detection method.
  #
  # @param sample [Greeb::Entity] a sample of entity to be cloned in the
  # process.
  # @param stop_marks [Array<Symbol>] an array that stores the
  # correspondent stop marks of the necessary entities.
  #
  # @return [Array<Greeb::Entity>] a set of entites.
  #
  def detect_entities(sample, stop_marks)
    collection = []

    rest = tokens.inject(sample.dup) do |entity, token|
      if !entity.from && SENTENCE_DOESNT_START.include?(token.type)
        next entity
      end

      entity.from = token.from unless entity.from

      next entity if entity.to && entity.to > token.to

      if stop_marks.include? token.type
        entity.to = tokens.select { |t| t.from >= token.from }.
          inject(token) { |r, t| break r if t.type != token.type; t }.to

        collection << entity
        entity = sample.dup
      elsif :separ != token.type
        entity.to = token.to
      end

      entity
    end

    if rest.from && rest.to
      collection << rest
    else
      collection
    end
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
