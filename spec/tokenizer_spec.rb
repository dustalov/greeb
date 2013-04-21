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
          [Entity.new(0, 5, :letter)]
        )
      end

      it 'can handle floats' do
        Tokenizer.tokenize('14.88').must_equal(
          [Entity.new(0, 5, :float)]
        )
      end

      it 'can handle integers' do
        Tokenizer.tokenize('1337').must_equal(
          [Entity.new(0, 4, :integer)]
        )
      end

      it 'can handle words and integers' do
        Tokenizer.tokenize('Hello, I am 18').must_equal(
          [Entity.new(0,  5,  :letter),
           Entity.new(5,  6,  :spunct),
           Entity.new(6,  7,  :separ),
           Entity.new(7,  8,  :letter),
           Entity.new(8,  9,  :separ),
           Entity.new(9,  11, :letter),
           Entity.new(11, 12, :separ),
           Entity.new(12, 14, :integer)]
        )
      end

      it 'can handle multi-line paragraphs' do
        Tokenizer.tokenize("Brateeshka..!\n\nPrines!").must_equal(
          [Entity.new(0,  10, :letter),
           Entity.new(10, 12, :punct),
           Entity.new(12, 13, :punct),
           Entity.new(13, 15, :break),
           Entity.new(15, 21, :letter),
           Entity.new(21, 22, :punct)]
        )
      end

      it 'can handle separated integers' do
        Tokenizer.tokenize('228/359').must_equal(
          [Entity.new(0, 3, :integer),
           Entity.new(3, 4, :separ),
           Entity.new(4, 7, :integer)]
        )
      end

      it 'can deal with Russian language' do
        Tokenizer.tokenize('Братишка, я тебе покушать принёс!').must_equal(
          [Entity.new(0,  8,  :letter),
           Entity.new(8,  9,  :spunct),
           Entity.new(9,  10, :separ),
           Entity.new(10, 11, :letter),
           Entity.new(11, 12, :separ),
           Entity.new(12, 16, :letter),
           Entity.new(16, 17, :separ),
           Entity.new(17, 25, :letter),
           Entity.new(25, 26, :separ),
           Entity.new(26, 32, :letter),
           Entity.new(32, 33, :punct)]
        )
      end
    end
  end
end
