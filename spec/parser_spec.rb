# encoding: utf-8

require File.expand_path('../spec_helper.rb', __FILE__)

describe Greeb::Parser do
  it 'should parse very simple strings' do
    'буба сука дебил'.should be_parsed_as([
      [
        [ [ 'буба', ' ', 'сука', ' ', 'дебил' ] ]
      ]
    ])
  end

  it 'should parse one sentence with subsentences' do
    'буба, сука, дебил'.should be_parsed_as([
      [
        [
          [ 'буба', ',' ],
          [ 'сука', ',' ],
          [ 'дебил' ]
        ]
      ]
    ])
  end

  it 'should parse two simple paragraphs' do
    "буба сука дебил\n\nточно!".should be_parsed_as([
      [
        [ [ 'буба', ' ', 'сука', ' ', 'дебил' ] ]
      ],
      [
        [ [ 'точно', '!' ] ]
      ]
    ])
  end

  it 'should parse two sentences in paragraph' do
    "буба молодец? буба умница.".should be_parsed_as([
      [
        [ [ 'буба', ' ', 'молодец', '?' ] ],
        [ [ 'буба', ' ', 'умница', '.' ] ]
      ]
    ])
  end

  it 'should parse sentences with floating point values' do
    'буба не считает Пи равной 3.14'.should be_parsed_as([
      [
        [ [ 'буба', ' ', 'не', ' ', 'считает', ' ',
            'Пи', ' ', 'равной', ' ', '3.14' ] ]
      ]
    ])
  end

  it 'should parse sentences with floating "dot" values' do
    'буба не считает Пи равной 3,14'.should be_parsed_as([
      [
        [ [ 'буба', ' ', 'не', ' ', 'считает', ' ',
            'Пи', ' ', 'равной', ' ', '3,14' ] ]
      ]
    ])
  end
end
