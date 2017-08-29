require "aemninja/version"
require "aemninja/errors"
require "aemninja/helpers"
require "aemninja/usage"
require "aemninja/aem"
require 'fileutils'

module Aemninja
  class Configuration
    attr_accessor :instances

    def initialize
      @instances = nil
    end
  end

  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end


  class Application

    ROOT_PATH=".aemninja"
    CONFIG_PATH = File.join(ROOT_PATH, "config")
    ENVIRONMENTS_PATH = File.join(CONFIG_PATH, "environments")
    ENVIRONMENT_CONFIG_FILE_LOCAL = File.join(ENVIRONMENTS_PATH, "local.rb")
    ENVIRONMENT_CONFIG_FILE_STAGING = File.join(ENVIRONMENTS_PATH, "staging.rb")
    ENVIRONMENT_CONFIG_FILE_PRODUCTION = File.join(ENVIRONMENTS_PATH, "production.rb")

    def init!
      if File.directory? ROOT_PATH
        Aemninja::Errors::already_initialized(ROOT_PATH)
      end

      Aemninja::Helpers::create_directory ROOT_PATH
      Aemninja::Helpers::create_directory CONFIG_PATH
      Aemninja::Helpers::create_directory ENVIRONMENTS_PATH

      Aemninja::Helpers::create_file ENVIRONMENT_CONFIG_FILE_LOCAL
      open(ENVIRONMENT_CONFIG_FILE_LOCAL, 'w') do |f|
        f.puts 'Aemninja.configure do |config|'
        f.puts '  config.instances = {'
        f.puts '    author: { host: "localhost:4502", user: "admin", password: "admin"},'
        f.puts '    publish: { host: "localhost:4503", user: "admin", password: "admin"}'
        f.puts '  }'
        f.puts 'end'
      end


      Aemninja::Helpers::create_file ENVIRONMENT_CONFIG_FILE_STAGING
      open(ENVIRONMENT_CONFIG_FILE_STAGING, 'w') do |f|
        f.puts 'Aemninja.configure do |config|'
        f.puts '  config.instances = {'
        f.puts '    author: { host: "localhost:4502", user: "admin", password: "admin"},'
        f.puts '    publish: { host: "localhost:4503", user: "admin", password: "admin"}'
        f.puts '  }'
        f.puts 'end'
      end

      Aemninja::Helpers::create_file ENVIRONMENT_CONFIG_FILE_PRODUCTION
      open(ENVIRONMENT_CONFIG_FILE_PRODUCTION, 'w') do |f|
        f.puts 'Aemninja.configure do |config|'
        f.puts '  config.instances = {'
        f.puts '    author: { host: "localhost:4502", user: "admin", password: "admin"},'
        f.puts '    publish: { host: "localhost:4503", user: "admin", password: "admin"}'
        f.puts '  }'
        f.puts 'end'
      end

      exit 0

    end

    def deploy!(package, environment='local')

      # Read Environment from Config File
      #host = "localhost:4503"
      #user = "admin"
      #password = "admin"


      # Do It
      if File.exists?(package)
         if File.file?(package)
          #puts 'deploy package ' + package +  ' to ' + environment

          package_without_path = Aemninja::Helpers::remove_path_from package
          stripped_pkg = Aemninja::Helpers::remove_path_and_version_from package

          puts "--------------------------------------------------------"
          puts "Deployment to \'#{environment}\' environment"
          puts "--------------------------------------------------------"
          puts
          puts "Configuration: .aemninja/config/environments/#{environment}.rb"
          puts

          require "./.aemninja/config/environments/#{environment}.rb"

          Aemninja.configuration.instances.each do |key, array|
            host = array[:host]
            user = array[:user]
            password = array[:password]

            puts
            puts key.to_s + " [" + host + "]"

            # puts "host: " + host
            # puts "user: " + user
            # puts "password: " + password

            installed_package_name = Aem::is_package_installed? host, user, password, stripped_pkg

            if installed_package_name != nil
              print  "  uninstall " + installed_package_name + " from " + host
              rc = Aem::uninstall host, user, password, installed_package_name
              if rc == true
                puts "   OK"
              else
                puts "   FAILED"
              end

              print "  delete " + installed_package_name + " from " + host
              rc = Aem::delete host, user, password, installed_package_name
              if rc == true
                puts "   OK"
              else
                puts "   FAILED"
              end

            else
              puts "  Package " + package_without_path + " not found on " + host + ". Skipping uninstall."
            end

            print "  install " + package + " to " + host
            rc = Aem::install host, user, password, package
            if rc == true
                puts "   OK"
              else
                puts "   FAILED"
              end
          end



         else
           Aemninja::Errors::not_a_file(package)
         end
      else
        Aemninja::Errors::does_not_exist(package)
      end

    exit 0
    end

    def no_valid_command
      Aemninja::Usage.commands
    end

  end
end
