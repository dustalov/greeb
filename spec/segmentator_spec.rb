# encoding: utf-8

require File.expand_path('../spec_helper', __FILE__)

module Greeb
  describe Segmentator do
    describe 'initialization' do
      before { @tokenizer = Tokenizer.new('Vodka') }

      subject { Segmentator.new(@tokenizer) }

      it 'can be initialized either with Tokenizer' do
        subject.tokens.must_be_kind_of SortedSet
      end

      it 'can be initialized either with a set of tokens' do
        subject = Segmentator.new(@tokenizer.tokens)
        subject.tokens.must_be_kind_of SortedSet
      end

      it 'should has @tokens ivar' do
        subject.instance_variable_get(:@tokens).wont_be_nil
      end
    end

    describe 'a simple sentence' do
      before { @tokenizer = Tokenizer.new('Hello, I am JC Denton.') }

      subject { Segmentator.new(@tokenizer).sentences }

      it 'should be segmented' do
        subject.must_equal(
          SortedSet.new([Entity.new(0, 22, :sentence)])
        )
      end
    end

    describe 'a simple sentence without punctuation' do
      before { @tokenizer = Tokenizer.new('Hello, I am JC Denton') }

      subject { Segmentator.new(@tokenizer).sentences }

      it 'should be segmented' do
        subject.must_equal(
          SortedSet.new([Entity.new(0, 21, :sentence)])
        )
      end
    end

    describe 'a simple sentence with trailing whitespaces' do
      before { @tokenizer = Tokenizer.new('      Hello, I am JC Denton  ') }

      subject { Segmentator.new(@tokenizer).sentences }

      it 'should be segmented' do
        subject.must_equal(
          SortedSet.new([Entity.new(6, 27, :sentence)])
        )
      end
    end

    describe 'two simple sentences' do
      before { @tokenizer = Tokenizer.new('Hello! I am JC Denton.') }

      subject { Segmentator.new(@tokenizer).sentences }

      it 'should be segmented' do
        subject.must_equal(
          SortedSet.new([Entity.new(0, 6,  :sentence),
                         Entity.new(7, 22, :sentence)])
        )
      end
    end

    describe 'one wrong character and one simple sentence' do
      before { @tokenizer = Tokenizer.new('! I am JC Denton.') }

      subject { Segmentator.new(@tokenizer).sentences }

      it 'should be segmented' do
        subject.must_equal(
          SortedSet.new([Entity.new(2, 17, :sentence)])
        )
      end
    end

    describe 'token extractor' do
      before { @tokenizer = Tokenizer.new('Hello! I am JC Denton.') }

      subject { Segmentator.new(@tokenizer) }

      let(:sentences) { subject.sentences }

      it 'should be extracted' do
        subject.extract(*sentences).must_equal({
          Entity.new(0,  6, :sentence) => [
            Entity.new(0, 5, :letter),
            Entity.new(5, 6, :punct)
          ],
          Entity.new(7, 22, :sentence) => [
            Entity.new(7,  8,  :letter),
            Entity.new(8,  9,  :separ),
            Entity.new(9,  11, :letter),
            Entity.new(11, 12, :separ),
            Entity.new(12, 14, :letter),
            Entity.new(14, 15, :separ),
            Entity.new(15, 21, :letter),
            Entity.new(21, 22, :punct)
          ]
        })
      end
    end
  end
end
