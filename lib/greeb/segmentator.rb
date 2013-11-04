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
      next entity if sentence_aint_start? entity, token
      entity.from = token.from unless entity.from
      next entity if entity.to and entity.to > token.to

      if stop_marks.include? token.type
        entity.to = find_forward(tokens, token).to
        collection << entity
        entity = sample.dup
      elsif ![:separ, :space].include? token.type
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
  # Check the possibility of starting a new sentence by the specified
  # pair of entity and token.
  #
  # @param entity [Greeb::Entity] an entity to be checked.
  # @param token [Greeb::Entity] an token to be checked.
  #
  # @return true or false.
  #
  def sentence_aint_start?(entity, token)
    !entity.from and SENTENCE_AINT_START.include? token.type
  end

  # Find a forwarding token that has another type.
  #
  # @param collection [Array<Greeb::Entity>] array of possible tokens.
  # @param sample [Greeb::Entity] a token that is treated as a sample.
  #
  # @return [Greeb::Entity] a forwarding token.
  #
  def find_forward(collection, sample)
    collection.select { |t| t.from >= sample.from }.
      inject(sample) { |r, t| t.type == sample.type ? t : (break r) }
  end

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
