# encoding: utf-8

require_relative 'spec_helper'

describe Span do
  describe 'argumentless derivation' do
    subject { Span.derivate }

    it 'should produce valid members' do
      subject.members.must_equal Span.members
    end

    it 'should produce a derived structure' do
      struct = subject.new(1, 2, 3)
      struct.from.must_equal 1
      struct.to.must_equal 2
      struct.type.must_equal 3
    end
  end

  describe 'common derivation' do
    subject { Span.derivate(:foo, :bar) }

    it 'should produce valid members' do
      subject.members.must_equal(Span.members + [:foo, :bar])
    end

    it 'should produce a derived structure' do
      struct = subject.new(1, 2, 3, 4)
      struct.from.must_equal 1
      struct.to.must_equal 2
      struct.type.must_equal 3
      struct.foo.must_equal 4

      struct.bar = 5
      struct.bar.must_equal 5
    end
  end

  describe 'comparison' do
    it 'should be comparable when positions are different' do
      (Span.new(1, 2) <=> Span.new(2, 3)).wont_equal 0
    end

    it 'should not be comparable when positions are same' do
      (Span.new(1, 2) <=> Span.new(1, 2)).must_equal 0
    end
  end

  describe 'equality' do
    it 'should be equal when positions are different' do
      Span.new(1, 2).wont_equal Span.new(2, 3)
    end

    it 'should not be equal when positions are same' do
      Span.new(1, 2).must_equal Span.new(1, 2)
    end

    it 'should not be equal when positions are same and types vary' do
      Span.new(1, 2, 3).wont_equal Span.new(1, 2, 4)
    end
  end
end
