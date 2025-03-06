module Foobara
  class LoadDotenv
    class << self
      def run!(...)
        new(...).execute
      end
    end

    EnvFile = Struct.new(:file_name, :envs, :is_local)

    attr_accessor :env, :dir, :env_files, :env_files_to_apply

    # Might be nice if we could grab the directory of the calling code instead of using Dir.pwd but not sure
    def initialize(env: ENV["DOTENV_ENV"] || ENV["FOOBARA_ENV"] || "development", dir: Dir.pwd)
      unless env
        # :nocov:
        raise ArgumentError, "env must be provided"
        # :nocov:
      end

      self.env = env.to_s
      self.dir = dir
    end

    def execute
      parse_env_file_names
      determine_env_files_to_apply
      sort_env_files
      apply_env_files
    end

    FILE_REGEX = /\A\.env((?:\.\w+)*?)(.local)?\z/

    def parse_env_file_names
      self.env_files = []

      Dir.entries(dir).each do |file_name|
        match = file_name.match(FILE_REGEX)

        next unless match

        envs = match[1]
        envs = envs[1..]&.split(".") if envs

        is_local = match[2]

        env_files << EnvFile.new(file_name, envs, is_local)
      end
    end

    def determine_env_files_to_apply
      self.env_files_to_apply = env_files.select do |env_file|
        envs = env_file.envs
        envs.nil? || envs.include?(env)
      end
    end

    def sort_env_files
      max_envs = env_files_to_apply.map { |env_file| env_file.envs&.length }.compact.max || 0

      env_files_to_apply.sort_by! do |env_file|
        envs = env_file.envs || []
        envs_length = envs.length

        [
          env_file.is_local ? 0 : 1,
          max_envs - envs_length + 1,
          envs.sort
        ]
      end
    end

    def apply_env_files
      unless env_files_to_apply.empty?
        Dir.chdir(dir) do
          Dotenv.load!(*env_files_to_apply.map(&:file_name))
        end
      end
    end
  end
end
