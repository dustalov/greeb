# encoding: utf-8

$:.push File.expand_path('../lib', __FILE__)
require 'greeb/version'

Gem::Specification.new do |s|
  s.name        = 'greeb'
  s.version     = Greeb::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = [ 'Dmitry A. Ustalov' ]
  s.email       = [ 'dmitry@eveel.ru' ]
  s.homepage    = 'https://github.com/eveel/greeb'
  s.summary     = 'Greeb is a Graphematical Analyzer.'
  s.description = 'Greeb is a Graphematical Analyzer, ' \
                  'written in Ruby.'

  s.rubyforge_project = 'greeb'

  s.add_dependency 'rspec', '~> 2.4.0'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = [ 'lib' ]
end
