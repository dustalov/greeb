# encoding: utf-8

require_relative 'spec_helper'

module Greeb
  describe Greeb do
    it 'should do nothing when ran without input' do
      Greeb[''].must_be_empty
    end

    it 'should tokenize text when input is given' do
      Greeb['Hello guys!'].must_equal(
        [Entity.new(0, 5, :letter),
         Entity.new(5, 6, :space),
         Entity.new(6, 10, :letter),
         Entity.new(10, 11, :punct)]
      )
    end

    it 'should extract URLs' do
      Greeb['Hello http://nlpub.ru guys!'].must_equal(
        [Entity.new(0, 5, :letter),
         Entity.new(5, 6, :space),
         Entity.new(6, 21, :url),
         Entity.new(21, 22, :space),
         Entity.new(22, 26, :letter),
         Entity.new(26, 27, :punct)]
      )
    end

    it 'should extract e-mails' do
      Greeb['Hello example@example.com guys!'].must_equal(
        [Entity.new(0, 5, :letter),
         Entity.new(5, 6, :space),
         Entity.new(6, 25, :email),
         Entity.new(25, 26, :space),
         Entity.new(26, 30, :letter),
         Entity.new(30, 31, :punct)]
      )
    end
  end
end
