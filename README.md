# Greeb

Greeb [grʲip] is a simple yet awesome and Unicode-aware text segmentator
based on regular expressions. The API documentation is available on
[RubyDoc.info]. The software demonstration is available on
<https://greeb.herokuapp.com>.

[![Gem Version][badge_fury_badge]][badge_fury_link] [![Dependency Status][gemnasium_badge]][gemnasium_link] [![Build Status][travis_ci_badge]][travis_ci_link] [![Code Climate][code_climate_badge]][code_climage_link]

[RubyDoc.info]: http://www.rubydoc.info/github/dustalov/greeb/master

[badge_fury_badge]: https://badge.fury.io/rb/greeb.svg
[badge_fury_link]: https://badge.fury.io/rb/greeb
[gemnasium_badge]: https://gemnasium.com/dustalov/greeb.svg
[gemnasium_link]: https://gemnasium.com/dustalov/greeb
[travis_ci_badge]: https://travis-ci.org/dustalov/greeb.svg
[travis_ci_link]: https://travis-ci.org/dustalov/greeb
[code_climate_badge]: https://codeclimate.com/github/dustalov/greeb/badges/gpa.svg
[code_climage_link]: https://codeclimate.com/github/dustalov/greeb

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

Greeb can approach such essential text processing problems as
tokenization and segmentation. There are two ways to use it:
1) as a command-line application, 2) as a Ruby library.

### Command-Line Interface

The `greeb` application reads the input text from `STDIN` and
writes one token per line to `STDOUT`.

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

Greeb has a very convenient API that makes you happy.

```ruby
pp Greeb::Tokenizer.tokenize('Hello!')
=begin
[#<struct Greeb::Span from=0, to=5, type=:letter>,
 #<struct Greeb::Span from=5, to=6, type=:punct>]
=end
```

It should be noted that it is also possible to process much
complex texts than the present one.

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

The analyzer can also perform sentence detection.

```ruby
text = 'Hello! How are you?'
tokens = Greeb::Tokenizer.tokenize(text)
pp Greeb::Segmentator.new(tokens).sentences
=begin
[#<struct Greeb::Span from=0, to=6, type=:sentence>,
 #<struct Greeb::Span from=7, to=19, type=:sentence>]
=end
```

Having obtained the sentence boundaries, it is possible to
extract tokens covered by these sentences.

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

It is often that a text includes such special entries as URLs
and e-mail addresses. Greeb can assist you in extracting them.

#### Extraction of URLs and e-mails

```ruby
text = 'My website is http://nlpub.ru and e-mail is example@example.com.'

pp Greeb::Parser.urls(text).map { |e| [e, e.slice(text)] }
=begin
[[#<struct Greeb::Span from=14, to=29, type=:url>, "http://nlpub.ru"]]
=end

pp Greeb::Parser.emails(text).map { |e| [e, e.slice(text)] }
=begin
[[#<struct Greeb::Span from=44, to=63, type=:email>, "example@example.com"]]
=end
```

Please do not use Greeb for the development of spam lists. Spam sucks.

#### Extraction of abbreviations

```ruby
text = 'Hello, G.L.H.F. everyone!'

pp Greeb::Parser.abbrevs(text).map { |e| [e, e.slice(text)] }
=begin
[[#<struct Greeb::Span from=7, to=15, type=:abbrev>, "G.L.H.F."]]
=end
```

The algorithm is not so accurate, but still useful in many practical
situations.

#### Extraction of time stamps

```ruby
text = 'Our time is running out: 13:37 or 14:89.'

pp Greeb::Parser.time(text).map { |e| [e, e.slice(text)] }
=begin
[[#<struct Greeb::Span from=25, to=30, type=:time>, "13:37"]]
=end
```

## Spans

Greeb operates with spans, which are tuples of *(from, to, kind)*, where
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

## DOI [<img src="https://zenodo.org/badge/doi/10.5281/zenodo.10119.png"/>](http://dx.doi.org/10.5281/zenodo.10119)

## Copyright

Copyright (c) 2010-2015 [Dmitry Ustalov]. See LICENSE for details.

[Dmitry Ustalov]: https://ustalov.name/
