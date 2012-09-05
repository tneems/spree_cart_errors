# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_cart_errors'
  s.version     = '1.2.0'
  s.summary     = 'Error messages on line overerages on spree stores'
  s.description = 'Error messages on line overerages on spree stores'
  s.required_ruby_version = '>= 1.9.3'

  s.author    = 'Tim Neems'
  s.email     = 'tneems@gmail.com'
  # s.homepage  = 'http://www.spreecommerce.com'

  #s.files       = `git ls-files`.split("\n")
  #s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '>= 1.2.0'
end
