# encoding: utf-8

require 'greeb/version'

# Greeb operates with tokens, tuples of `<from, to, kind>`, where
# `from` is a beginning of the token, `to` is an ending of the token,
# and `kind` is a type of the token.
#
# There are several token types: `:letter`, `:float`, `:integer`,
# `:separ` for separators, `:punct` for punctuation characters,
# `:spunct` for in-sentence punctuation characters, and
# `:break` for line endings.
#
class Greeb::Entity < Struct.new(:from, :to, :type); end

require 'greeb/tokenizer'
