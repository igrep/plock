# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'plock/version'

Gem::Specification.new do |spec|
  spec.name          = "plock"
  spec.version       = Plock::VERSION
  spec.authors       = ["Yamamoto Yuji"]
  spec.email         = ["whosekiteneverfly@gmail.com"]
  spec.description   = %q{'p { 1 + 1 }` prints "1 + 1 #=> 2". That's all.}
  spec.summary       = %q{'p { 1 + 1 }` prints "1 + 1 #=> 2". That's all.}
  spec.homepage      = "https://github.com/igrep/plock"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
