require_relative "src/version"

Gem::Specification.new do |spec|
  spec.name = "foobara-load-dotenv"
  spec.version = Foobara::LoadDotenv::VERSION
  spec.authors = ["Miles Georgi"]
  spec.email = ["azimux@gmail.com"]

  spec.summary = "Loads .env* files in a certain desirable order."
  spec.homepage = "https://github.com/foobara/load-dotenv"
  spec.license = "MIT"
  # probably works with older versions but might not test that unless needed
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[
                        bin/
                        spec/
                        Gemfile
                        Gemfile.lock
                        .git
                        .github
                        .gitignore
                        Rakefile
                        README.md
                        .rspec
                        .rubocop.yml
                      ])
    end
  end
  spec.require_paths = ["lib"]

  spec.add_dependency "dotenv"
  spec.metadata["rubygems_mfa_required"] = "true"
end
