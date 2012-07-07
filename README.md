Greeb
=====

Greeb is a simple yet awesome text tokenizer that is based on regular
expressions.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'greeb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install greeb

## Usage

Greeb can help you to solve simple text processing problems:

```ruby
pp Greeb::Tokenizer.new('Hello!').tokens
=begin
#<SortedSet: {#<struct Greeb::Entity from=0, to=5, type=:letter>,
 #<struct Greeb::Entity from=5, to=6, type=:punct>}>
=end
```

It should be noted that it is possible to process much complex texts:

```ruby
text =<<-EOF
Hello! I am 18! My favourite number is 133.7...

What about you?
EOF

pp Greeb::Tokenizer.new(text).tokens
=begin
#<SortedSet: {#<struct Greeb::Entity from=0, to=5, type=:letter>,
 #<struct Greeb::Entity from=5, to=6, type=:punct>,
 #<struct Greeb::Entity from=6, to=7, type=:separ>,
 #<struct Greeb::Entity from=7, to=8, type=:letter>,
 #<struct Greeb::Entity from=8, to=9, type=:separ>,
 #<struct Greeb::Entity from=9, to=11, type=:letter>,
 #<struct Greeb::Entity from=11, to=12, type=:separ>,
 #<struct Greeb::Entity from=12, to=14, type=:integer>,
 #<struct Greeb::Entity from=14, to=15, type=:punct>,
 #<struct Greeb::Entity from=15, to=16, type=:separ>,
 #<struct Greeb::Entity from=16, to=18, type=:letter>,
 #<struct Greeb::Entity from=18, to=19, type=:separ>,
 #<struct Greeb::Entity from=19, to=28, type=:letter>,
 #<struct Greeb::Entity from=28, to=29, type=:separ>,
 #<struct Greeb::Entity from=29, to=35, type=:letter>,
 #<struct Greeb::Entity from=35, to=36, type=:separ>,
 #<struct Greeb::Entity from=36, to=38, type=:letter>,
 #<struct Greeb::Entity from=38, to=39, type=:separ>,
 #<struct Greeb::Entity from=39, to=44, type=:float>,
 #<struct Greeb::Entity from=44, to=47, type=:punct>,
 #<struct Greeb::Entity from=47, to=49, type=:break>,
 #<struct Greeb::Entity from=49, to=53, type=:letter>,
 #<struct Greeb::Entity from=53, to=54, type=:separ>,
 #<struct Greeb::Entity from=54, to=59, type=:letter>,
 #<struct Greeb::Entity from=59, to=60, type=:separ>,
 #<struct Greeb::Entity from=60, to=63, type=:letter>,
 #<struct Greeb::Entity from=63, to=64, type=:punct>,
 #<struct Greeb::Entity from=64, to=65, type=:break>}>
=end
```

Also it can be used to solve the text segmentation problems
such as sentence detection tasks:

```ruby
text = 'Hello! How are you?'
pp Greeb::Segmentator.new(Greeb::Tokenizer.new(text))
=begin
#<SortedSet: {#<struct Greeb::Entity from=0, to=6, type=:sentence>,
 #<struct Greeb::Entity from=7, to=19, type=:sentence>}>
=end
```

## Tokens

Greeb operates with entities, tuples of `<from, to, type>`, where
`from` is a beginning of the entity, `to` is an ending of the entity,
and `type` is a type of the entity.

There are several entity types: `:letter`, `:float`, `:integer`,
`:separ`, `:punct` (for punctuation), `:spunct` (for in-sentence
punctuation), and `:break`.

## Contributing

1. Fork it;
2. Create your feature branch (`git checkout -b my-new-feature`);
3. Commit your changes (`git commit -am 'Added some feature'`);
4. Push to the branch (`git push origin my-new-feature`);
5. Create new Pull Request.

I highly recommend you to use git flow to make development process much
systematic and awesome.

## Build Status [<img src="https://secure.travis-ci.org/eveel/greeb.png"/>](http://travis-ci.org/eveel/greeb)

## Dependency Status [<img src="https://gemnasium.com/eveel/greeb.png?travis"/>](https://gemnasium.com/eveel/greeb)

## Copyright

Copyright (c) 2010-2012 [Dmitry A. Ustalov]. See LICENSE for details.

[Dmitry A. Ustalov]: http://eveel.ru
