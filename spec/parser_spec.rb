# encoding: utf-8

require_relative 'spec_helper'

describe Parser do
  let(:text) do
    ('Hello there! My name is <span class="name">Vasya B.</span> and ' \
     'I am к.ф.-м.н. My website is http://вася.рф/. And my e-mail is ' \
     'example@example.com! It is available by URL: http://vasya.ru. '  \
     'Also, <b>G.L.H.F.</b> everyone! It\'s 13:37 or 00:02:28 right '  \
     'now, not 14:89. What about some Nagibator228?').freeze
  end

  let(:spans) { Tokenizer.tokenize(text) }

  describe 'URL' do
    subject { Parser.urls(text) }

    it 'recognizes URLs' do
      subject.must_equal(
        [Span.new(92, 107, :url),
         Span.new(171, 186, :url)]
      )
    end
  end

  describe 'EMAIL' do
    subject { Parser.emails(text) }

    it 'recognizes e-mails' do
      subject.must_equal(
        [Span.new(126, 145, :email)]
      )
    end
  end

  describe 'ABBREV' do
    subject { Parser.abbrevs(text) }

    it 'recognizes abbreviations' do
      subject.must_equal(
        [Span.new(49, 51, :abbrev),
         Span.new(68, 77, :abbrev),
         Span.new(197, 205, :abbrev)]
      )
    end
  end

  describe 'HTML' do
    subject { Parser.html(text) }

    it 'recognizes HTML entities' do
      subject.must_equal(
        [Span.new(24, 43, :html),
         Span.new(51, 58, :html),
         Span.new(194, 197, :html),
         Span.new(205, 209, :html)]
      )
    end
  end

  describe 'TIME' do
    subject { Parser.time(text) }

    it 'recognizes timestamps' do
      subject.must_equal(
        [Span.new(225, 230, :time),
         Span.new(234, 242, :time)]
      )
    end
  end

  describe 'APOSTROPHE' do
    subject { Parser.apostrophes(text, spans.dup) }

    it 'recognizes apostrophes' do
      subject.must_equal(
        [Span.new(220, 224, :letter)]
      )
    end
  end

  describe 'TOGETHER' do
    subject { Parser.together(spans.dup) }

    it 'merges connected spans' do
      subject.select { |s| s.type == :together }.must_equal(
        [Span.new(281, 293, :together)]
      )
    end
  end
end
