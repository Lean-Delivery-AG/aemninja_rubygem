require "aemninja/version"
require "aemninja/errors"
require "aemninja/helpers"
require "aemninja/usage"
require 'fileutils'

module Aemninja
  class Application

    ROOT_PATH=".aemninja"
    CONFIG_PATH = File.join(ROOT_PATH, "config")
    ENVIRONMENTS_PATH = File.join(CONFIG_PATH, "environments")
    ENVIRONMENT_CONFIG_FILE_LOCAL = File.join(ENVIRONMENTS_PATH, "local.rb")
    ENVIRONMENT_CONFIG_FILE_STAGING = File.join(ENVIRONMENTS_PATH, "staging.rb")
    ENVIRONMENT_CONFIG_FILE_PRODUCTION = File.join(ENVIRONMENTS_PATH, "production.rb")

    def init!
      if File.directory? ROOT_PATH
        Aemninja::Errors::not_a_directory(pkg)
      end

      Aemninja::Helpers::create_directory ROOT_PATH
      Aemninja::Helpers::create_directory CONFIG_PATH
      Aemninja::Helpers::create_directory ENVIRONMENTS_PATH
      Aemninja::Helpers::create_file ENVIRONMENT_CONFIG_FILE_LOCAL
      Aemninja::Helpers::create_file ENVIRONMENT_CONFIG_FILE_STAGING
      Aemninja::Helpers::create_file ENVIRONMENT_CONFIG_FILE_PRODUCTION

      exit 0

    end

    def deploy!(pkg, environment='local')
      if File.exists?(pkg)
         if File.file?(pkg)
          puts 'deploying ' + pkg +  ' to ' + environment
         else
           Aemninja::Errors::not_a_file(pkg)
         end
      else
        Aemninja::Errors::does_not_exist(pkg)
      end

    exit 0
    end

    def no_valid_command
      Aemninja::Usage.commands
    end

  end
end
