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
EOL = /^\n+$/u
SEP = /^[*=_ ]$/u
PNC = /^(\.|\!|\?|\[|\]|\(|\)|\-|:|;)$/u
DIG = /^[0-9]+$/u
DIL = /^[А-Яа-яA-Za-z0-9]+$/u
EMPTY = ''

def parse(origin)
  text = [ [ [ ] ] ]

  paragraph_id = 0
  sentence_id = 0

  token = ''

  origin.each_char do |c|
    p [ c, token ]
    case c
      when EOL then begin
        case token
          when EMPTY then token << c
          when EOL then begin
            token = ''
            text << [ [ ] ]
            paragraph_id = text.size - 1
            sentence_id = 0
          end
          else
            text[paragraph_id][sentence_id] << token
            token = c
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
          when EOL then token = c
          else token << c
        end
      end
      when EN_LEX then begin
        case token
          when EOL then token = c
          else token << c
        end
      end
      when DIG then begin
        case token
          when EOL then token = c
          else token << c
        end
      end
      when DIL then begin
        case token
          when EOL then token = c
          else token << c
        end
      end
    end
  end

  text[paragraph_id][sentence_id] << token

  text
end

p parse(origin)
