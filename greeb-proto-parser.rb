#!/usr/bin/env ruby
# encoding: utf-8

origin = <<-END
 - Сынок, чего это от тебя зигами пахнет,
опять на Манежную площадь ходил?

 - Нет мама, я в метро ехал, там назиговано было!

Четырнадцать, восемьдесять восемь: 14/88.
Вот так блять.
END
origin.chomp!

RU_LEX = /^[А-Яа-я]+$/u
EN_LEX = /^[A-Za-z]+$/u
PAR = /^(\n)+$/u
SEP = /^[*=_ ]$/u
PNC = /^(\.|\!|\?|\[|\]|\(|\)|\-|:|;)$/u
DIG = /^[0-9]+$/u
DIL = /^[А-Яа-яA-Za-z0-9]+$/u
EMPTY = /^$/u

def parse(origin)
  text = [ [ [ ] ] ]

  paragraph_id = 0
  sentence_id = 0
  token_id = 0

  token = ''

  while c = origin[token_id]
    case c
      when PAR then begin
        case token
          when EMPTY then token << c
          when PAR then token << c
          else
            text[paragraph_id][sentence_id] << token
            token = c
            text << [ [ ] ]
            paragraph_id += 1
            sentence_id = 0
        end
      end
      when SEP then begin
        unless token.empty?
          text[paragraph_id][sentence_id] << token
        end
        text[paragraph_id][sentence_id] << c
        token = ''
      end
      when RU_LEX then begin
        case token
          when PAR then token = c
          else token << c
        end
      end
      when EN_LEX then begin
        case token
          when PAR then token = c
          else token << c
        end
      end
      when DIG then begin
        case token
          when PAR then token = c
          else token << c
        end
      end
      when DIL then begin
        case token
          when PAR then token = c
          else token << c
        end
      end
    end

    token_id += 1
  end

  text[paragraph_id][sentence_id] << token

  text
end

p parse(origin)
