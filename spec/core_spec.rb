# encoding: utf-8

require_relative 'spec_helper'

describe Greeb do
  it 'should do nothing when ran without input' do
    Greeb[''].must_be_empty
  end

  it 'should tokenize text when input is given' do
    Greeb['Hello guys!'].must_equal(
      [Span.new(0, 5, :letter),
       Span.new(5, 6, :space),
       Span.new(6, 10, :letter),
       Span.new(10, 11, :punct)]
    )
  end

  it 'should extract URLs' do
    Greeb['Hello http://nlpub.ru guys!'].must_equal(
      [Span.new(0, 5, :letter),
       Span.new(5, 6, :space),
       Span.new(6, 21, :url),
       Span.new(21, 22, :space),
       Span.new(22, 26, :letter),
       Span.new(26, 27, :punct)]
    )
  end

  it 'should extract e-mails' do
    Greeb['Hello example@example.com guys!'].must_equal(
      [Span.new(0, 5, :letter),
       Span.new(5, 6, :space),
       Span.new(6, 25, :email),
       Span.new(25, 26, :space),
       Span.new(26, 30, :letter),
       Span.new(30, 31, :punct)]
    )
  end
end
