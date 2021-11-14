$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "adeia/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "adeia"
  s.version     = Adeia::VERSION
  s.authors     = ["khcr"]
  s.email       = ["kocher.ke@gmail.com"]
  s.homepage    = "http://github.com/JS-Tech/adeia"
  s.summary     = "An authorization gem for Rails that allows you to have the complete control of your app."
  s.description = s.summary
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 6.0"
  s.add_dependency "snaptable", "~> 4.0"

  s.add_development_dependency "sqlite3", "~> 1.4"
  s.add_development_dependency "sassc-rails", "~> 2.1"
  s.add_development_dependency "bcrypt", "~> 3.1"
  s.add_development_dependency "rspec-rails", "~> 5.0"
  s.add_development_dependency "rspec-activemodel-mocks", "~> 1.1"
  s.add_development_dependency "rails-controller-testing", "~> 1.0"
  s.add_development_dependency "factory_bot_rails", "~> 6.2"
  s.add_development_dependency "capybara", "~> 3.36"
end
