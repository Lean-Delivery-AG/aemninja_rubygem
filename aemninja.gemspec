# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aemninja/version'

Gem::Specification.new do |spec|
  spec.name          = "aemninja"
  spec.version       = Aemninja::VERSION
  spec.authors       = ["Samuel Fawaz"]
  spec.email         = ["sfawaz@gmail.com"]

  spec.summary       = %q{AEM scripting Gem}
  spec.description   = %q{Reduces complexity of AEM tasks.}
  spec.homepage      = "http://www.github.com/aemninja"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = ["aemninja"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
end
