# encoding: utf-8

require File.expand_path('../spec_helper', __FILE__)

module Greeb
  describe Segmentator do
    describe 'initialization' do
      let(:tokens) { Tokenizer.tokenize('Vodka') }

      subject { Segmentator.new(tokens) }

      it 'is initialized either with set of tokens' do
        subject.tokens.must_be_kind_of Array
      end

      it 'should has @tokens ivar' do
        subject.instance_variable_get(:@tokens).wont_be_nil
      end
    end

    describe 'a simple sentence' do
      let(:tokens) { Tokenizer.tokenize('Hello, I am JC Denton.') }

      subject { Segmentator.new(tokens).sentences }

      it 'should be segmented' do
        subject.must_equal([Entity.new(0, 22, :sentence)])
      end
    end

    describe 'a simple sentence without punctuation' do
      let(:tokens) { Tokenizer.tokenize('Hello, I am JC Denton') }

      subject { Segmentator.new(tokens).sentences }

      it 'should be segmented' do
        subject.must_equal([Entity.new(0, 21, :sentence)])
      end
    end

    describe 'a simple sentence with trailing whitespaces' do
      let(:tokens) { Tokenizer.tokenize('      Hello, I am JC Denton  ') }

      subject { Segmentator.new(tokens).sentences }

      it 'should be segmented' do
        subject.must_equal([Entity.new(6, 27, :sentence)])
      end
    end

    describe 'two simple sentences' do
      let(:tokens) { Tokenizer.tokenize('Hello! I am JC Denton.') }

      subject { Segmentator.new(tokens).sentences }

      it 'should be segmented' do
        subject.must_equal([Entity.new(0, 6,  :sentence),
                            Entity.new(7, 22, :sentence)])
      end
    end

    describe 'one wrong character and one simple sentence' do
      let(:tokens) { Tokenizer.tokenize('! I am JC Denton.') }

      subject { Segmentator.new(tokens).sentences }

      it 'should be segmented' do
        subject.must_equal([Entity.new(2, 17, :sentence)])
      end
    end

    describe 'sentence extractor' do
      let(:tokens) { Tokenizer.tokenize('Hello! I am JC Denton.') }
      let(:segmentator) { Segmentator.new(tokens) }

      subject { segmentator.extract(*segmentator.sentences) }

      it 'should be extracted' do
        subject.must_equal(
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
        )
      end
    end

    describe 'subsentence extractor' do
      let(:tokens) { Tokenizer.tokenize('Hello, I am JC Denton.') }
      let(:segmentator) { Segmentator.new(tokens) }

      subject { segmentator.subextract(*segmentator.sentences) }

      it 'should extract subsentences' do
        subject.must_equal(
          Entity.new(0,  22, :sentence) => [
            Entity.new(0, 6, :subsentence),
            Entity.new(7, 22, :subsentence)
          ]
        )
      end
    end
  end
end
