# encoding: utf-8

class Greeb::Segmentator
  SENTENCE_DOESNT_START = [:separ, :break, :punct, :spunct]

  attr_reader :tokens

  def initialize tokenizer_or_tokens
    @tokens = if tokenizer_or_tokens.is_a? Greeb::Tokenizer
      tokenizer_or_tokens.tokens
    else
      tokenizer_or_tokens
    end
  end

  def sentences
    sentences = SortedSet.new

    last = tokens.inject(Greeb::Entity.new(nil, nil, :sentence)) do |sentence, token|
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

        sentences << sentence
        sentence = Greeb::Entity.new(nil, nil, :sentence)
      elsif :separ != token.type
        sentence.to = token.to
      end

      sentence
    end

    sentences << last if last.from and last.to

    sentences
  end

  def extract *sentences
    Hash[
      sentences.map do |s|
        [s, tokens.select { |t| t.from >= s.from and t.to <= s.to }]
      end
    ]
  end
end
