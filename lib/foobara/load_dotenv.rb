require "dotenv"

module Foobara
  class LoadDotenv
  end
end

# TODO: replace this with Util.require_directory when Util is in its own repository.
Dir["#{__dir__}/../../src/**/*.rb"].each { |f| require f }
