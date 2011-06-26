Greeb
=====

Greeb is awesome Graphematical Analyzer (text segmentator),
which parser is based on Finite State Machine.
You can see state diagram
[right here](https://github.com/eveel/greeb/raw/master/greeb-diagram.png).

Greeb can be used in basic text segmentation tasks:

    text =<<-EOF
    привет,
    красавица!

    тепло ли тебе?
    END
    tree = Greeb::Parser.new(text).parse

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so
  I don't break it in a future version
  unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is
  fine but bump version in a commit by itself
  I can ignore when I pull)
* Send me a pull request. Bonus points for
  topic branches.

## Copyright

Copyright (c) 2010-2011 Dmitry A. Ustalov.
See LICENSE for details.
