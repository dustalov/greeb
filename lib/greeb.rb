# encoding: utf-8

require 'greeb/version'

# Greeb operates with entities, tuples of `<from, to, kind>`, where
# `from` is a beginning of the entity, `to` is an ending of the entity,
# and `kind` is a type of the entity.
#
# There are several entity types: `:letter`, `:float`, `:integer`,
# `:separ` for separators, `:punct` for punctuation characters,
# `:spunct` for in-sentence punctuation characters, and
# `:break` for line endings.
#
class Greeb::Entity < Struct.new(:from, :to, :type)
  def <=> other
    return 0 if self.from <=> other.from
    self.to <=> other.to
  end
end

require 'greeb/tokenizer'
require 'greeb/segmentator'
