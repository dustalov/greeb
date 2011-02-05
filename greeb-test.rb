#!/usr/bin/env ruby
# encoding: utf-8

require 'rubygems'
require 'graphviz'

$:.unshift('./lib')
require 'greeb'

origin = <<-END
 - Сынок, чего это     от тебя   зигами пахнет,
опять на Манежную площадь ходил?

 - Нет мама, я в метро ехал, там  назиговано было!!

  

Четырнадцать, восемьдесять восемь: 14/88.
Вот так блять
END
origin.chomp!

def identify(token)
  case token
    when Greeb::RU_LEX then 'RU_LEX'
    when Greeb::EN_LEX then 'EN_LEX'
    when Greeb::EOL then 'EOL'
    when Greeb::SEP then 'SEP'
    when Greeb::PUN then 'PUN'
    when Greeb::SPUN then 'SPUN'
    when Greeb::DIG then 'DIG'
    when Greeb::DIL then 'DIL'
  else
    '?!'
  end
end

greeb = Greeb::Parser.new(origin)
text = greeb.tree

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
