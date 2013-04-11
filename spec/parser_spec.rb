# encoding: utf-8

require_relative 'spec_helper'

module Greeb
  describe Parser do
    let(:text) do
      'Hello there! My name is Vasya. My website is: http://вася.рф/. ' \
      'And my e-mail is example@example.com! Also it is available by ' \
      'URL: http://vasya.ru.'
    end

    describe 'URL' do
      subject { Parser.urls(text) }

      it 'recognizes URLs' do
        subject.must_equal(
          [Entity.new(46, 61, :url),
           Entity.new(129, 144, :url)]
        )
      end
    end

    describe 'EMAIL' do
      subject { Parser.emails(text) }

      it 'recognizes e-mails' do
        subject.must_equal(
          [Entity.new(80, 99, :email)]
        )
      end
    end
  end
end
