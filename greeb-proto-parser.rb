#!/usr/bin/env ruby
# encoding: utf-8

origin = <<-END
 - Сынок, чего это     от тебя   зигами пахнет,
опять на Манежную площадь ходил?

 - Нет мама, я в метро ехал, там  назиговано было!

  

Четырнадцать, восемьдесять восемь: 14/88.
Вот так блять.
END
origin.chomp!

RU_LEX = /^[А-Яа-я]+$/u
EN_LEX = /^[A-Za-z]+$/u
EOL = /^\n+$/u
SEP = /^[*=_ ]$/u
PUN = /^(\.|\!|\?|\[|\]|\(|\)|\-|:|;)$/u
DIG = /^[0-9]+$/u
DIL = /^[А-Яа-яA-Za-z0-9]+$/u
EMPTY = ''

def parse(origin)
  text = [ [ [ ] ] ]

  paragraph_id = 0
  sentence_id = 0

  token = ''

  puts '# Finite-State Automata'
  origin.each_char do |c|
    puts "[#{token.inspect}] ← #{c.inspect}"
    case c
      when EOL then begin
        case token
          when EMPTY then token << c
          when EOL then begin
            token = ''
            text << [ [ ] ]
            paragraph_id = text.size - 1
#            paragraph_id += 1
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
        while text[paragraph_id][sentence_id].last == c
          text[paragraph_id][sentence_id].pop
        end
        text[paragraph_id][sentence_id] << c
        token = ''
      end
      when PUN then begin
        case token
          when EMPTY
          else
            text[paragraph_id][sentence_id] << token
            text[paragraph_id][sentence_id] << c
            token = ''
            text[paragraph_id] << []
            sentence_id = text[paragraph_id].size - 1
#            sentence_id += 1
        end
      end
      when RU_LEX then begin
        case token
          when EOL then begin
            text[paragraph_id][sentence_id] << ' '
            token = c
          end
          else token << c
        end
      end
      when EN_LEX then begin
        case token
          when EOL then begin
            text[paragraph_id][sentence_id] << ' '
            token = c
          end
          else token << c
        end
      end
      when DIG then begin
        case token
          when EOL then begin
            text[paragraph_id][sentence_id] << ' '
            token = c
          end
          else token << c
        end
      end
      when DIL then begin
        case token
          when EOL then begin
            text[paragraph_id][sentence_id] << token
            token = c
          end
          else token << c
        end
      end
    end
  end

  text[paragraph_id][sentence_id] << token

  text
end

text = parse(origin)

puts '# Parsing Result'
p text

puts '# Text Interpretation'
pure = text.map do |paragraph|
  paragraph.map do |sentence|
    sentence.join
  end.join(' ')
end.join("\n\n")
puts pure
