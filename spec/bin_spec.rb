# encoding: utf-8

require_relative 'spec_helper'

describe 'CLI' do
  it 'should do nothing when ran without input' do
    invoke('').must_be_empty
  end

  it 'should tokenize text when input is given' do
    invoke(stdin: 'Hello guys!').must_equal(
      %w(Hello guys !))
  end

  it 'should extract URLs' do
    invoke(stdin: 'Hello http://nlpub.ru guys!').must_equal(
      %w(Hello http://nlpub.ru guys !))
  end

  it 'should extract e-mails' do
    invoke(stdin: 'Hello example@example.com guys!').must_equal(
      %w(Hello example@example.com guys !))
  end

  it 'should print version' do
    invoke('-v').join.must_match(/\AGreeb (\d\.)+\d\z/)
  end

  it 'should print help' do
    invoke('-h').join.must_match(/Usage/)
  end
end
