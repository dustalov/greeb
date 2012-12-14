# encoding: utf-8

require File.expand_path('../lib/greeb/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'greeb'
  s.version     = Greeb::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Dmitry Ustalov']
  s.email       = ['dmitry@eveel.ru']
  s.homepage    = 'https://github.com/eveel/greeb'
  s.summary     = 'Greeb is a simple Unicode-aware regexp-based tokenizer.'
  s.description = 'Greeb is a simple yet awesome and Unicode-aware ' \
                  'regexp-based tokenizer, written in Ruby.'

  s.rubyforge_project = 'greeb'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'minitest', '>= 2.11'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'yard'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
end
