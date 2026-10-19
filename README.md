# Foobara::LoadDotenv

`foobara-dotenv-loader` is a gem which provides `Foobara::LoadDotenv`, a loader that picks the right `.env` files for your environment and loads them in a consistent, conventional order.

## Installation

Add `gem "foobara-dotenv-loader"` to your Gemfile or .gemspec file and `bundle install`. Or even just `gem install foobara-dotenv-loader` if just playing with it directly in the scripts.

## Usage

Running the loader with explicit arguments:

```ruby
Foobara::LoadDotenv.run!(env: "test", dir: Dir.pwd)
```

Here `env: "test"` picks the `test` environment, and `dir: Dir.pwd` picks the folder which in this case is the current working directory.

When the loader is run without any arguments, as in the code below, it uses default values to decide which environment to use. It checks the `DOTENV_ENV` environment variable first, then `FOOBARA_ENV` next, and if neither of these is set, the loader will use `development` as the default environment.

```ruby
require "foobara/load_dotenv"

Foobara::LoadDotenv.run!
```

NOTE: The gem overwrites any environment variables already set in your terminal or system when it loads the matching `.env` files.

### Which files load and in what order

File names and the environments they load in:

- `.env` is loaded in all environments.
- `.env.development` is only loaded if `env` is `"development"`.
- `.env.development.test` is only loaded if `env` is `"development"` or `"test"`.

The same pattern applies if you add more environment names to a file name.

You can append `.local` to the file if it contains local overrides not meant to be checked into source control.

Be sure to add something like:

```gitignore
**/.env.*.local
**/.env.local
```

to your `.gitignore` if using git to honor this.

### The order they load in

- Values in `.local` files have a higher precedent than values in non-local files. This lets them override the values in others.
- Values in environment-specific files like `.env.development` have a higher precedent than those in `.env`.

Below is the order the project's tests check, from highest precedence to lowest:

1. `.env.development.test.local`
2. `.env.development.local`
3. `.env.local`
4. `.env.development.test`
5. `.env.development`
6. `.env`

So the most specific, most local file is first, and then the plain shared `.env` is last.

## Contributing

Bug reports and pull requests are welcome at [foobara/load-dotenv](https://github.com/foobara/load-dotenv).

To work on an existing issue or submit a Pull Request:

1. Fork the repository and clone it to your local machine
2. Run `bundle install` to install dependencies
3. Run `rake` to ensure that everything works as expected before making any changes.
4. Implement your changes
5. Re-run `rake` to make sure that all tests and rubocop pass
6. Commit your changes, push to GitHub and open a Pull Request for review

## License

This project is licensed under the MPL-2.0 license. Please see [LICENSE.txt](LICENSE.text) for more information.
