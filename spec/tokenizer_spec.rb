# encoding: utf-8

require_relative 'spec_helper'

module Greeb
  describe Tokenizer do
    describe 'after tokenization' do
      subject { Tokenizer.tokenize('vodka') }

      it 'should has the tokens set' do
        subject.must_be_kind_of Array
      end
    end

    describe 'tokenization facilities' do
      it 'can handle words' do
        Tokenizer.tokenize('hello').must_equal(
          [Span.new(0, 5, :letter)]
        )
      end

      it 'can handle floats' do
        Tokenizer.tokenize('14.88').must_equal(
          [Span.new(0, 5, :float)]
        )
      end

      it 'can handle integers' do
        Tokenizer.tokenize('1337').must_equal(
          [Span.new(0, 4, :integer)]
        )
      end

      it 'can handle words and integers' do
        Tokenizer.tokenize('Hello, I am 18').must_equal(
          [Span.new(0,  5,  :letter),
           Span.new(5,  6,  :spunct),
           Span.new(6,  7,  :space),
           Span.new(7,  8,  :letter),
           Span.new(8,  9,  :space),
           Span.new(9,  11, :letter),
           Span.new(11, 12, :space),
           Span.new(12, 14, :integer)]
        )
      end

      it 'can handle multi-line paragraphs' do
        Tokenizer.tokenize("Brateeshka..!\n\nPrines!").must_equal(
          [Span.new(0,  10, :letter),
           Span.new(10, 12, :punct),
           Span.new(12, 13, :punct),
           Span.new(13, 15, :break),
           Span.new(15, 21, :letter),
           Span.new(21, 22, :punct)]
        )
      end

      it 'can handle separated integers' do
        Tokenizer.tokenize('228/359').must_equal(
          [Span.new(0, 3, :integer),
           Span.new(3, 4, :separ),
           Span.new(4, 7, :integer)]
        )
      end

      it 'can deal with Russian language' do
        Tokenizer.tokenize('Братишка, я тебе покушать принёс!').must_equal(
          [Span.new(0,  8,  :letter),
           Span.new(8,  9,  :spunct),
           Span.new(9,  10, :space),
           Span.new(10, 11, :letter),
           Span.new(11, 12, :space),
           Span.new(12, 16, :letter),
           Span.new(16, 17, :space),
           Span.new(17, 25, :letter),
           Span.new(25, 26, :space),
           Span.new(26, 32, :letter),
           Span.new(32, 33, :punct)]
        )
      end
    end

    describe '.split' do
      it 'should split characters' do
        Tokenizer.split('loh').must_equal %w(l o h)
      end

      it 'should combine duplicated characters' do
        Tokenizer.split('foo').must_equal %w(f oo)
      end

      it 'should also deal with line breaks' do
        Tokenizer.split("bar\n\nbaz").must_equal(
          [*%w(b a r), "\n\n", *%w(b a z)])
      end
    end
  end
end
