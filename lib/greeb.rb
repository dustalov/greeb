# encoding: utf-8

require 'meta_array'
require 'enumerable'

module Greeb
  RU_LEX = /^[А-Яа-яЁё]+$/u
  EN_LEX = /^[A-Za-z]+$/u
  EOL = /^\n+$/u
  SEP = /^[*=_\/\\ ]$/u
  PUN = /^(\.|\!|\?)$/u
  SPUN = /^(\,|\[|\]|\(|\)|\-|:|;)$/u
  DIG = /^[0-9]+$/u
  DIL = /^[А-Яа-яA-Za-z0-9Ёё]+$/u
  EMPTY = ''

  class Parser
    attr_accessor :origin
    private :origin=

    attr_writer :tree
    private :tree=

    def initialize(origin)
      self.origin = origin
    end

    def tree
      @tree ||= parse(origin)
    end

    private
      def parse(origin) # :nodoc:
        tree = MetaArray.new

        # paragraph
        p_id = 0

        # sentence
        s_id = 0

        # subsentence
        ss_id = 0

        token = ''

        origin.each_char do |c|
          case c
            when EOL then begin
              case token
                when EMPTY then token << c
                when EOL then begin
                  token = ''
                  p_id += 1
                  s_id = 0
                  ss_id = 0
                end
              else
                tree[p_id][s_id][ss_id] << token
                token = c
              end
            end
            when SEP then begin
              case token
                when EMPTY
              else
                tree[p_id][s_id][ss_id] << token
                while tree[p_id][s_id][ss_id].last == c
                  tree[p_id][s_id][ss_id].pop
                end
                tree[p_id][s_id][ss_id] << c
                token = ''
              end
            end
            when PUN then begin
              case token
                when EMPTY
              else
                tree[p_id][s_id][ss_id] << token
                tree[p_id][s_id][ss_id] << c
                token = ''
                s_id += 1
                ss_id = 0
              end
            end
            when SPUN then begin
              case token
                when EMPTY
              else
                tree[p_id][s_id][ss_id] << token
                tree[p_id][s_id][ss_id] << c
                token = ''
                ss_id += 1
              end
            end
            when RU_LEX then begin
              case token
                when EOL then begin
                  tree[p_id][s_id][ss_id] << ' '
                  token = c
                end
              else
                token << c
              end
            end
            when EN_LEX then begin
              case token
                when EOL then begin
                  tree[p_id][s_id][ss_id] << ' '
                  token = c
                end
              else
                token << c
              end
            end
            when DIG then begin
              case token
                when EOL then begin
                  tree[p_id][s_id][ss_id] << ' '
                  token = c
                end
              else
                token << c
              end
            end
            when DIL then begin
              case token
                when EOL then begin
                  tree[p_id][s_id][ss_id] << token
                  token = c
                end
              else
                token << c
              end
            end
          end
        end
        tree[p_id][s_id][ss_id] << token
        tree.delete(nil)
        tree.to_a
      end
  end
end
