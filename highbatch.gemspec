
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "highbatch/version"

Gem::Specification.new do |spec|
  spec.name          = "highbatch"
  spec.version       = Highbatch::VERSION
  spec.authors       = ["tom.dulin"]
  spec.email         = ["tomldulin@gmail.com"]


  spec.summary       = %q{playlist managment tool}
  spec.description   = %q{Given an input file and change file, output a modified playlist based on changes in change file.}
  spec.homepage      = "https://github.com/tomdulin/highbatch"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = ['highbatch']
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rb-readline"
end
