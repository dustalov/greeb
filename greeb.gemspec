# encoding: utf-8

require File.expand_path('../lib/greeb/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name        = 'greeb'
  spec.version     = Greeb::VERSION
  spec.platform    = Gem::Platform::RUBY
  spec.authors     = ['Dmitry Ustalov']
  spec.email       = ['dmitry@eveel.ru']
  spec.homepage    = 'https://github.com/dustalov/greeb'
  spec.summary     = 'Greeb is a simple Unicode-aware regexp-based tokenizer.'
  spec.description = 'Greeb is a simple yet awesome and Unicode-aware ' \
                     'regexp-based tokenizer, written in Ruby.'
  spec.license     = 'MIT'

  spec.required_ruby_version = '>= 1.9.1'

  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'minitest', '~> 5.0'
end
