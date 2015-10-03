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
  s.summary     = "A Rails plugin which add authentification and a permissions control system."
  s.description = s.summary
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.4"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "bcrypt-ruby"
  s.add_development_dependency "rspec-rails"
end
