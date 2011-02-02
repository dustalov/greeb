#!/usr/bin/env ruby
# encoding: utf-8

require 'pp'
require 'rubygems'
require 'graphviz'

origin = <<-END
 - Сынок, чего это     от тебя   зигами пахнет,
опять на Манежную площадь ходил?

 - Нет мама, я в метро ехал, там  назиговано было!!

  

Четырнадцать, восемьдесять восемь: 14/88.
Вот так блять
END
origin.chomp!

RU_LEX = /^[А-Яа-я]+$/u
EN_LEX = /^[A-Za-z]+$/u
EOL = /^\n+$/u
SEP = /^[*=_\/\\ ]$/u
PUN = /^(\.|\!|\?)$/u
SPUN = /^(\,|\[|\]|\(|\)|\-|:|;)$/u
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

module Enumerable
  def collect_with_index(i = -1)
    collect { |e| yield(e, i += 1) }
  end
  alias map_with_index collect_with_index
end


def parse(origin)
  text = MetaArray.new

  paragraph_id = 0
  sentence_id = 0
  subsentence_id = 0

  token = ''

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
            subsentence_id = 0
          end
        else
          text[paragraph_id][sentence_id][subsentence_id] << token
          token = c
        end
      end
      when SEP then begin
        case token
          when EMPTY
        else
          text[paragraph_id][sentence_id][subsentence_id] << token
          while text[paragraph_id][sentence_id][subsentence_id].last == c
            text[paragraph_id][sentence_id][subsentence_id].pop
          end
          text[paragraph_id][sentence_id][subsentence_id] << c
          token = ''
        end
      end
      when PUN then begin
        case token
          when EMPTY
        else
          text[paragraph_id][sentence_id][subsentence_id] << token
          text[paragraph_id][sentence_id][subsentence_id] << c
          token = ''
          sentence_id += 1
          subsentence_id = 0
        end
      end
      when SPUN then begin
        case token
          when EMPTY
        else
          text[paragraph_id][sentence_id][subsentence_id] << token
          text[paragraph_id][sentence_id][subsentence_id] << c
          token = ''
          subsentence_id += 1
        end
      end
      when RU_LEX then begin
        case token
          when EOL then begin
            text[paragraph_id][sentence_id][subsentence_id] << ' '
            token = c
          end
        else
          token << c
        end
      end
      when EN_LEX then begin
        case token
          when EOL then begin
            text[paragraph_id][sentence_id][subsentence_id] << ' '
            token = c
          end
        else
          token << c
        end
      end
      when DIG then begin
        case token
          when EOL then begin
            text[paragraph_id][sentence_id][subsentence_id] << ' '
            token = c
          end
        else
          token << c
        end
      end
      when DIL then begin
        case token
          when EOL then begin
            text[paragraph_id][sentence_id][subsentence_id] << token
            token = c
          end
        else
          token << c
        end
      end
    end
  end

  text[paragraph_id][sentence_id][subsentence_id] << token
  text.delete(nil)
  text
end

def identify(token)
  case token
    when RU_LEX then 'RU_LEX'
    when EN_LEX then 'EN_LEX'
    when EOL then 'EOL'
    when SEP then 'SEP'
    when PUN then 'PUN'
    when SPUN then 'SPUN'
    when DIG then 'DIG'
    when DIL then 'DIL'
  else
    '?!'
  end
end

text = parse(origin)

#puts '# Parsing Result'
#pp text

#puts '# Text Interpretation'
#pure = text.map do |paragraph|
#  paragraph.map do |sentence|
#    sentence.join
#  end.join(' ')
#end.join("\n\n")
#puts pure

g = GraphViz.new('graphematics', 'type' => 'graph')

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
g.edge[:fontname] = 'PT Sans'
g.edge[:fontcolor]= '#444444'
g.edge[:fontsize] = '6'
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

tree = text.map_with_index do |paragraph, i|
  pid = "p#{i}"
  sentences = paragraph.map_with_index do |sentence, j|
    sid = "#{pid}s#{j}"
    subsentences = sentence.map_with_index do |subsentence, k|
      ssid = "#{sid}ss#{k}"
      tokens = subsentence.map_with_index do |token, l|
        next if ' ' == token
        [ "#{ssid}t#{l}", token, l ]
      end
      tokens.delete(nil)
      [ ssid, tokens, k ]
    end
    [ sid, subsentences, j ]
  end
  [ pid, sentences, i ]
end

tree.each do |pid, paragraph, i|
  g.add_node(pid).tap do |node|
    node.label = "Абзац\n№#{i + 1}"
    node.shape = 'ellipse'
  end
  g.add_edge(bid, pid)

  paragraph.each do |sid, sentence, j|
    g.add_node(sid).tap do |node|
      node.label = "Предложение\n№#{j + 1}"
      node.shape = 'ellipse'
    end
    g.add_edge(pid, sid)

    sentence.each do |ssid, subsentence, k|
      g.add_node(ssid).tap do |node|
        node.label = "Подпредложение\n№#{k + 1}"
        node.shape = 'ellipse'
      end
      g.add_edge(sid, ssid)

      subsentence.each do |tid, token, l|
        g.add_node(tid).label = token
        g.add_edge(ssid, tid).label = identify(token)
        g.add_edge(tid, eid)
      end

      subsentence.each_cons(2) do |(tid1, token1, l1),
                                   (tid2, token2, l2)|
        g.add_edge(tid1, tid2).tap do |edge|
          edge.weight = 0.25
          edge.style = 'dashed'
        end
      end
    end

    sentence.each_cons(2) do |(ssid1, subsentence1, k1),
                              (ssid2, subsentence2, k2)|
      tid1, token1, l1 = subsentence1.last
      tid2, token2, l2 = subsentence2.first
      g.add_edge(tid1, tid2).tap do |edge|
        edge.weight = 0.5
        edge.style = 'dashed'
      end
    end
  end
end

g.output(:output => 'png', :file => 'graph.png')
