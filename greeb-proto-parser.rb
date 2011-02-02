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

class MetaArray < Array
  def [] id
    super(id) or begin
      self.class.new.tap do |element|
        self[id] = element
      end
    end
  end
end

def parse(origin)
  text = MetaArray.new

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
            paragraph_id += 1
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
            sentence_id += 1
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

#  text[paragraph_id][sentence_id] << token

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

require 'rubygems'
require 'graphviz'

g = GraphViz.new('graphematics', 'type' => 'graph')
#g[:rankdir] = 'LR'

g.node[:color]    = '#ddaa66'
g.node[:style]    = 'filled'
g.node[:shape]    = 'box'
g.node[:penwidth] = '1'
g.node[:fontname] = 'PT Sans'
g.node[:fontsize] = '8'
g.node[:fillcolor]= '#ffeecc'
g.node[:fontcolor]= '#775500'
g.node[:margin]   = '0.0'

g.edge[:color]    = '#999999'
g.edge[:weight]   = '1'
g.edge[:fontsize] = '6'
g.edge[:fontcolor]= '#444444'
g.edge[:fontname] = 'PT Serif'
g.edge[:dir]      = 'forward'
g.edge[:arrowsize]= '0.5'

bid = 'begin'
g.add_node(bid).tap do |node|
  node.label = "Начало\nтекста"
  node.shape = 'ellipse'
  node.style = ''
end

eid = 'end'
g.add_node(eid).tap do |node|
  node.label = "Конец\nтекста"
  node.shape = 'ellipse'
  node.style = ''
end

text.each_with_index do |paragraph, i|
  pid = "p#{i}"
  g.add_node(pid).tap do |node|
    node.label = "Абзац №#{i + 1}"
    node.shape = 'ellipse'
  end
  g.add_edge(bid, pid)
  paragraph.each_with_index do |sentence, j|
    sid = "p#{i}s#{j}"
    g.add_node(sid).tap do |node|
      node.label = "Предложение №#{j + 1}"
      node.shape = 'ellipse'
    end
    g.add_edge(pid, sid)
    sentence.each_with_index do |token, k|
      next if ' ' == token
      tid = "p#{i}s#{j}t#{k}"
      g.add_node(tid).label = token
      g.add_edge(sid, tid)
      g.add_edge(tid, eid)
    end
  end
end

g.output(:output => 'png', :file => 'graph.png')
