# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'syncsign/version'

Gem::Specification.new do |s|
  s.name = "syncsign"
  s.version = SyncSign::VERSION

  s.description = "Interface library for SyncSign e-paper displays"
  s.homepage = "http://github.com/sarahemm/ruby-syncsign"
  s.summary = "SyncSign interface library"
  s.licenses = "MIT"
  s.authors = ["sarahemm"]
  s.email = "github@sen.cx"
  
  s.files = Dir.glob("{lib,spec}/**/*") + %w(README.md Rakefile)
  s.require_path = "lib"

  s.rubygems_version = "1.3.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
end
