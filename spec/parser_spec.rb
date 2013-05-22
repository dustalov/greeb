# encoding: utf-8

require_relative 'spec_helper'

module Greeb
  describe Parser do
    let(:text) do
      'Hello there! My name is Vasya B. My website is: http://вася.рф/. ' \
      'And my e-mail is example@example.com! Also it is available by ' \
      'URL: http://vasya.ru. Also, G.L.H.F. to everybody!'
    end

    describe 'URL' do
      subject { Parser.urls(text) }

      it 'recognizes URLs' do
        subject.must_equal(
          [Entity.new(48, 63, :url),
           Entity.new(132, 147, :url)]
        )
      end
    end

    describe 'EMAIL' do
      subject { Parser.emails(text) }

      it 'recognizes e-mails' do
        subject.must_equal(
          [Entity.new(82, 101, :email)]
        )
      end
    end

    describe 'ABBREV' do
      subject { Parser.abbrevs(text) }

      it 'recognizes abbreviations' do
        subject.must_equal(
          [Entity.new(30, 32, :abbrev),
           Entity.new(155, 163, :abbrev)]
        )
      end
    end
  end
end
