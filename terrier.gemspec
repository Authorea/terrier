# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'terrier/version'

Gem::Specification.new do |spec|
  spec.name          = "terrier"
  spec.version       = Terrier::VERSION
  spec.authors       = ["Matthew Bergman", "Winnower"]
  spec.email         = ["mzbphoto@gmail.com"]
  spec.summary       = %q{Terrier: Import Doi and Zenodo Papers}
  spec.description   = %q{Terrier is used to retrieve metadata of scholarly works from a variety of sources.  Terrier can be used to pull metadata on any article that has been issued a digital object identifier (DOI) or that is hosted on the Zenodo Repository, maintained by CERN.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency('httparty', '~> 0')
  spec.add_dependency 'nokogiri', "~> 1.6.7"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "vcr", "~> 2.9.3"
  spec.add_development_dependency "webmock", "~> 1.24.1"

end
