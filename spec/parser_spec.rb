# encoding: utf-8

require_relative 'spec_helper'

module Greeb
  describe Parser do
    let(:text) do
      'Hello there! My name is Vasya B. and I am к.ф.-м.н. My website is ' \
      'http://вася.рф/. And my e-mail is example@example.com! Also it is ' \
      'available by URL: http://vasya.ru. Also, G.L.H.F. everyone!'
    end

    describe 'URL' do
      subject { Parser.urls(text) }

      it 'recognizes URLs' do
        subject.must_equal(
          [Entity.new(66, 81, :url),
           Entity.new(150, 165, :url)]
        )
      end
    end

    describe 'EMAIL' do
      subject { Parser.emails(text) }

      it 'recognizes e-mails' do
        subject.must_equal(
          [Entity.new(100, 119, :email)]
        )
      end
    end

    describe 'ABBREV' do
      subject { Parser.abbrevs(text) }

      it 'recognizes abbreviations' do
        subject.must_equal(
          [Entity.new(30, 32, :abbrev),
           Entity.new(42, 51, :abbrev),
           Entity.new(173, 181, :abbrev)]
        )
      end
    end
  end
end
