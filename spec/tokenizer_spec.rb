# encoding: utf-8

require File.expand_path('../spec_helper', __FILE__)

module Greeb
  describe Tokenizer do
    describe 'initialization' do
      subject { Tokenizer.new('vodka') }

      it 'should be initialized with a text' do
        subject.text.must_equal 'vodka'
      end

      it 'should has the @text ivar' do
        subject.instance_variable_get(:@text).must_equal 'vodka'
      end

      it 'should not has @tokens ivar' do
        subject.instance_variable_get(:@tokens).must_be_nil
      end
    end

    describe 'after tokenization' do
      subject { Tokenizer.new('vodka').tap(&:tokens) }

      it 'should has the @tokens ivar' do
        subject.instance_variable_get(:@tokens).wont_be_nil
      end

      it 'should has the @scanner ivar' do
        subject.instance_variable_get(:@scanner).wont_be_nil
      end

      it 'should has the tokens set' do
        subject.tokens.must_be_kind_of SortedSet
      end
    end

    describe 'tokenization facilities' do
      it 'can handle words' do
        Tokenizer.new('hello').tokens.must_equal(
          SortedSet.new([Entity.new(0, 5, :letter)])
        )
      end

      it 'can handle floats' do
        Tokenizer.new('14.88').tokens.must_equal(
          SortedSet.new([Entity.new(0, 5, :float)])
        )
      end

      it 'can handle integers' do
        Tokenizer.new('1337').tokens.must_equal(
          SortedSet.new([Entity.new(0, 4, :integer)])
        )
      end

      it 'can handle words and integers' do
        Tokenizer.new('Hello, I am 18').tokens.must_equal(
          SortedSet.new([Entity.new(0,  5,  :letter),
                         Entity.new(5,  6,  :spunct),
                         Entity.new(6,  7,  :separ),
                         Entity.new(7,  8,  :letter),
                         Entity.new(8,  9,  :separ),
                         Entity.new(9,  11, :letter),
                         Entity.new(11, 12, :separ),
                         Entity.new(12, 14, :integer)])
        )
      end

      it 'can handle multi-line paragraphs' do
        Tokenizer.new("Brateeshka..!\n\nPrines!").tokens.must_equal(
          SortedSet.new([Entity.new(0,  10, :letter),
                         Entity.new(10, 12, :punct),
                         Entity.new(12, 13, :punct),
                         Entity.new(13, 15, :break),
                         Entity.new(15, 21, :letter),
                         Entity.new(21, 22, :punct)])
        )
      end

      it 'can handle separated integers' do
        Tokenizer.new('228/359').tokens.must_equal(
          SortedSet.new([Entity.new(0, 3, :integer),
                         Entity.new(3, 4, :separ),
                         Entity.new(4, 7, :integer)])
        )
      end
    end
  end
end
