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
#<Set: {#<struct Greeb::Tokenizer::Token from=0, to=5, kind=:letter>,
 #<struct Greeb::Tokenizer::Token from=5, to=6, kind=:punct>}>
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
#<Set: {#<struct Greeb::Tokenizer::Token from=0, to=5, kind=:letter>,
 #<struct Greeb::Tokenizer::Token from=5, to=6, kind=:punct>,
 #<struct Greeb::Tokenizer::Token from=6, to=7, kind=:separ>,
 #<struct Greeb::Tokenizer::Token from=7, to=8, kind=:letter>,
 #<struct Greeb::Tokenizer::Token from=8, to=9, kind=:separ>,
 #<struct Greeb::Tokenizer::Token from=9, to=11, kind=:letter>,
 #<struct Greeb::Tokenizer::Token from=11, to=12, kind=:separ>,
 #<struct Greeb::Tokenizer::Token from=12, to=14, kind=:integer>,
 #<struct Greeb::Tokenizer::Token from=14, to=15, kind=:punct>,
 #<struct Greeb::Tokenizer::Token from=15, to=16, kind=:separ>,
 #<struct Greeb::Tokenizer::Token from=16, to=18, kind=:letter>,
 #<struct Greeb::Tokenizer::Token from=18, to=19, kind=:separ>,
 #<struct Greeb::Tokenizer::Token from=19, to=28, kind=:letter>,
 #<struct Greeb::Tokenizer::Token from=28, to=29, kind=:separ>,
 #<struct Greeb::Tokenizer::Token from=29, to=35, kind=:letter>,
 #<struct Greeb::Tokenizer::Token from=35, to=36, kind=:separ>,
 #<struct Greeb::Tokenizer::Token from=36, to=38, kind=:letter>,
 #<struct Greeb::Tokenizer::Token from=38, to=39, kind=:separ>,
 #<struct Greeb::Tokenizer::Token from=39, to=44, kind=:float>,
 #<struct Greeb::Tokenizer::Token from=44, to=47, kind=:punct>,
 #<struct Greeb::Tokenizer::Token from=47, to=49, kind=:break>,
 #<struct Greeb::Tokenizer::Token from=49, to=53, kind=:letter>,
 #<struct Greeb::Tokenizer::Token from=53, to=54, kind=:separ>,
 #<struct Greeb::Tokenizer::Token from=54, to=59, kind=:letter>,
 #<struct Greeb::Tokenizer::Token from=59, to=60, kind=:separ>,
 #<struct Greeb::Tokenizer::Token from=60, to=63, kind=:letter>,
 #<struct Greeb::Tokenizer::Token from=63, to=64, kind=:punct>,
 #<struct Greeb::Tokenizer::Token from=64, to=65, kind=:break>}>
=end
```

## Tokens

Greeb operates with tokens, a tuples of `<from, to, kind>`, where
`from` is a beginning of the token, `to` is an ending of the token,
and `kind` is a type of the token.

There are several token types: `:letter`, `:float`, `:integer`,
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
