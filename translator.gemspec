# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = "translator"
  s.version     = "0.1.0"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Hubert Łępicki", "Luis Doubrava"]
  s.email       = ["hubert.lepicki@amberbit.com"]
  s.homepage    = "http://github.com/cgservices/translator"
  s.summary     = "Rails engine to manage translations"
  s.description = "translator is engine, that you can easily integrate with your administration panel, and let your clients do the dirty work translating the site"

  s.required_ruby_version = '>= 1.9.4'

  s.files        = Dir.glob("{app,lib,config}/**/*") + %w(LICENSE README.rdoc)
  s.require_path = 'lib'

  s.add_dependency 'rails'
  s.add_dependency 'i18n'
  s.add_dependency 'redis'
  s.add_dependency 'ya2yaml'
  s.add_dependency 'bootstrap-sass'
  s.add_dependency 'sass-rails'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'jquery-ui-rails'
  s.add_dependency 'select2-rails'

end
