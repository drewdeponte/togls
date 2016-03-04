# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'togls/version'

Gem::Specification.new do |spec|
  spec.name          = 'togls'
  spec.version       = Togls::VERSION
  spec.authors       = ['Brian Miller', 'Andrew DePonte', 'Ryan Hedges']
  spec.email         = ['brimil01@gmail.com', 'cyphactor@gmail.com',
                        'ryanhedges@gmail.com']

  spec.summary       = 'An ultra light weight yet ridiculously powerful' \
                       'ruby feature toggle gem.'
  spec.description   = 'An ultra light weight yet ridiculously powerful' \
                       ' ruby feature toggle gem that supports the concept' \
                       ' of release toggles and business toggles.'
  spec.homepage      = 'http://github.com/codebreakdown/togls'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split('\x0').reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.2'
  spec.add_development_dependency 'pry', '~> 0.10'
end
