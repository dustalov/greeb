# Greeb
Greeb [grʲip] is a simple yet awesome and Unicode-aware text segmentator
that is based on regular expressions. API documentation is available at
<http://rubydoc.info/github/dmchk/greeb/master/frames>.

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
Greeb can help you solve simple text processing problems such as
tokenization and segmentation.

It is available as a command line application that reads the input
text from STDIN and prints one token per line into STDOUT.

```
% echo 'Hello http://nlpub.ru guys, how are you?' | greeb
Hello
http://nlpub.ru
guys
,
how
are
you
?
```

### Tokenization API
Greeb has a very convinient API that makes you happy.

```ruby
pp Greeb::Tokenizer.tokenize('Hello!')
=begin
[#<struct Greeb::Span from=0, to=5, type=:letter>,
 #<struct Greeb::Span from=5, to=6, type=:punct>]
=end
```

It should be noted that it is possible to process much complex texts.

```ruby
text =<<-EOF
Hello! I am 18! My favourite number is 133.7...

What about you?
EOF

pp Greeb::Tokenizer.tokenize(text)
=begin
[#<struct Greeb::Span from=0, to=5, type=:letter>,
 #<struct Greeb::Span from=5, to=6, type=:punct>,
 #<struct Greeb::Span from=6, to=7, type=:space>,
 #<struct Greeb::Span from=7, to=8, type=:letter>,
 #<struct Greeb::Span from=8, to=9, type=:space>,
 #<struct Greeb::Span from=9, to=11, type=:letter>,
 #<struct Greeb::Span from=11, to=12, type=:space>,
 #<struct Greeb::Span from=12, to=14, type=:integer>,
 #<struct Greeb::Span from=14, to=15, type=:punct>,
 #<struct Greeb::Span from=15, to=16, type=:space>,
 #<struct Greeb::Span from=16, to=18, type=:letter>,
 #<struct Greeb::Span from=18, to=19, type=:space>,
 #<struct Greeb::Span from=19, to=28, type=:letter>,
 #<struct Greeb::Span from=28, to=29, type=:space>,
 #<struct Greeb::Span from=29, to=35, type=:letter>,
 #<struct Greeb::Span from=35, to=36, type=:space>,
 #<struct Greeb::Span from=36, to=38, type=:letter>,
 #<struct Greeb::Span from=38, to=39, type=:space>,
 #<struct Greeb::Span from=39, to=44, type=:float>,
 #<struct Greeb::Span from=44, to=47, type=:punct>,
 #<struct Greeb::Span from=47, to=49, type=:break>,
 #<struct Greeb::Span from=49, to=53, type=:letter>,
 #<struct Greeb::Span from=53, to=54, type=:space>,
 #<struct Greeb::Span from=54, to=59, type=:letter>,
 #<struct Greeb::Span from=59, to=60, type=:space>,
 #<struct Greeb::Span from=60, to=63, type=:letter>,
 #<struct Greeb::Span from=63, to=64, type=:punct>,
 #<struct Greeb::Span from=64, to=65, type=:break>]
=end
```

### Segmentation API
Also it can be used to solve the text segmentation problems
such as sentence detection tasks.

```ruby
text = 'Hello! How are you?'
tokens = Greeb::Tokenizer.tokenize(text)
pp Greeb::Segmentator.new(tokens).sentences
=begin
[#<struct Greeb::Span from=0, to=6, type=:sentence>,
 #<struct Greeb::Span from=7, to=19, type=:sentence>]
=end
```

It is possible to extract tokens that were processed by the text
segmentator.

```ruby
text = 'Hello! How are you?'
tokens = Greeb::Tokenizer.tokenize(text)
segmentator = Greeb::Segmentator.new(tokens)
pp segmentator.extract(segmentator.sentences)
=begin
{#<struct Greeb::Span from=0, to=6, type=:sentence>=>
  [#<struct Greeb::Span from=0, to=5, type=:letter>,
   #<struct Greeb::Span from=5, to=6, type=:punct>],
 #<struct Greeb::Span from=7, to=19, type=:sentence>=>
  [#<struct Greeb::Span from=7, to=10, type=:letter>,
   #<struct Greeb::Span from=10, to=11, type=:space>,
   #<struct Greeb::Span from=11, to=14, type=:letter>,
   #<struct Greeb::Span from=14, to=15, type=:space>,
   #<struct Greeb::Span from=15, to=18, type=:letter>,
   #<struct Greeb::Span from=18, to=19, type=:punct>]}
=end
```

### Parsing API
Texts are often include some special spans such as URLs and e-mail
addresses. Greeb can help you in these strings retrieval.

#### URL and E-mail retrieval
```ruby
text = 'My website is http://nlpub.ru and e-mail is example@example.com.'

pp Greeb::Parser.urls(text).map { |e| [e, text[e.from...e.to]] }
=begin
[[#<struct Greeb::Span from=14, to=29, type=:url>, "http://nlpub.ru"]]
=end

pp Greeb::Parser.emails(text).map { |e| [e, text[e.from...e.to]] }
=begin
[[#<struct Greeb::Span from=44, to=63, type=:email>, "example@example.com"]]
=end
```

Please don't use Greeb in spam lists development purposes.

#### Abbreviation retrieval
```ruby
text = 'Hello, G.L.H.F. everyone!'

pp Greeb::Parser.abbrevs(text).map { |e| [e, text[e.from...e.to]] }
=begin
[[#<struct Greeb::Span from=7, to=15, type=:abbrev>, "G.L.H.F."]]
=end
```

The algorithm is not so accurate, but still useful in many practical
situations.

## Tokens
Greeb operates with spans, tuples of *(from, to, kind)*, where
*from* is a beginning of the span, *to* is an ending of the span,
and *kind* is a type of the span.

There are several span types at the tokenization stage: `:letter`,
`:float`, `:integer`, `:separ`, `:punct` (for punctuation), `:spunct`
(for in-sentence punctuation), `:space`, and `:break`.

## Contributing
1. Fork it;
2. Create your feature branch (`git checkout -b my-new-feature`);
3. Commit your changes (`git commit -am 'Added some feature'`);
4. Push to the branch (`git push origin my-new-feature`);
5. Create new Pull Request.

## Build Status [<img src="https://secure.travis-ci.org/dmchk/greeb.png"/>](http://travis-ci.org/dmchk/greeb)

## Dependency Status [<img src="https://gemnasium.com/dmchk/greeb.png"/>](https://gemnasium.com/dmchk/greeb)

## Code Climate [<img src="https://codeclimate.com/github/dmchk/greeb.png"/>](https://codeclimate.com/github/dmchk/greeb)

## Copyright

Copyright (c) 2010-2013 [Dmitry Ustalov]. See LICENSE for details.

[Dmitry Ustalov]: http://eveel.ru
