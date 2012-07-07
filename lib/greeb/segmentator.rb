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

    last = tokens.inject(Greeb::Entity.new) do |sentence, token|
      next sentence if !sentence.from and SENTENCE_DOESNT_START.include?(token.type)
      sentence.from = token.from unless sentence.from

      next sentence if sentence.to and sentence.to > token.to

      case token.type
      when :punct then begin
        finish = tokens.
          select { |t| t.from >= token.from }.
          inject(token) { |r, t| break r unless t.type == token.type; t }
        sentences << sentence.tap { |s| s.to = finish.to }
        sentence = Greeb::Entity.new
      end
      when :separ then
      else
        sentence.to = token.to
      end

      sentence.tap { |s| s.type = :sentence }
    end

    sentences << last if last.from && last.to

    sentences
  end
end
