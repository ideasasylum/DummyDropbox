# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dummy_dropbox}
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jamie Lawrence"]
  s.date = %q{2011-03-30}
  s.description = %q{Dummy monkey patching for the dropbox ruby gem: http://rubygems.org/gems/dropbox}
  s.email = %q{hopeless@gmail.com}
  s.extra_rdoc_files = ["README.rdoc", "lib/dummy_dropbox.rb"]
  s.files = ["Manifest", "README.rdoc", "Rakefile", "lib/dummy_dropbox.rb", "test/dummy_dropbox_test.rb", "test/fixtures/dropbox/file1.txt", "test/fixtures/dropbox/folder1/file2.txt", "test/fixtures/dropbox/folder1/file3.txt", "test/fixtures/dropbox/test.jpg", "test/fixtures/file.txt", "dummy_dropbox.gemspec"]
  s.homepage = %q{http://github.com/hopeless/DummyDropbox}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Dummy_dropbox", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{dummy_dropbox}
  s.rubygems_version = %q{1.5.2}
  s.summary = %q{Dummy monkey patching for the dropbox ruby gem: http://rubygems.org/gems/dropbox}
  s.test_files = ["test/dummy_dropbox_test.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<dropbox>, [">= 0"])
    else
      s.add_dependency(%q<dropbox>, [">= 0"])
    end
  else
    s.add_dependency(%q<dropbox>, [">= 0"])
  end
end
