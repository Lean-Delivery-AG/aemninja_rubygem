require "aemninja/version"
require 'fileutils'

module Aemninja
  ROOT_PATH="aemninja"
  CONFIG_PATH = "config"
  ENVIRONMENTS_PATH = File.join(CONFIG_PATH, "environments")
  DEVELOPMENT_ENVIRONMENT_FILE = File.join(ENVIRONMENTS_PATH, "development.rb")

  VENDOR_PATH = "vendor"
  AEM_BINARY_PATH = File.join(VENDOR_PATH, "aem")
  AEM_BINARY_FILE = File.join(AEM_BINARY_PATH, "aem-author-p4502.jar")
  AEM_BINARY_LICENSE_FILE = File.join(AEM_BINARY_PATH, "license.properties")

  AEM_INSTANCES_PATH = "aem_instances"
  AEM_INSTANCES_AUTHOR_PATH = File.join(AEM_INSTANCES_PATH, "author")
  AEM_INSTANCES_PUBLISH_PATH = File.join(AEM_INSTANCES_PATH, "publish")
  AEM_INSTANCES_AUTHOR_BINARY = File.join(AEM_INSTANCES_AUTHOR_PATH, "aem-author-p4502.jar")
  AEM_INSTANCES_AUTHOR_LICENSE = File.join(AEM_INSTANCES_AUTHOR_PATH, "license.properties")
  AEM_INSTANCES_PUBLISH_BINARY = File.join(AEM_INSTANCES_AUTHOR_PATH, "aem-publish-p4503.jar")
  AEM_INSTANCES_PUBLISH_LICENSE = File.join(AEM_INSTANCES_AUTHOR_PATH, "license.properties")

  module Commands
    def self.deploy!(environment='local')
      puts 'deploying to ' + environment

      exit 0
    end
    def self.init!

      if File.directory? ROOT_PATH
        puts "It seems like aemninja has already been initialized in this directory. 'aemninja' folder already exists!"
        exit 1
      end

      config_path                  = File.join(ROOT_PATH, CONFIG_PATH)
      environments_path            = File.join(ROOT_PATH, ENVIRONMENTS_PATH)
      development_environment_file = File.join(ROOT_PATH, DEVELOPMENT_ENVIRONMENT_FILE)
      vendor_path                  = File.join(ROOT_PATH, VENDOR_PATH)
      aem_binary_path              = File.join(ROOT_PATH, AEM_BINARY_PATH)
      aem_instances_path           = File.join(ROOT_PATH, AEM_INSTANCES_PATH)
      aem_instances_author_path    = File.join(ROOT_PATH, AEM_INSTANCES_AUTHOR_PATH)
      aem_instances_publish_path   = File.join(ROOT_PATH, AEM_INSTANCES_PUBLISH_PATH)

      create_directory config_path
      create_directory environments_path
      create_file development_environment_file
      create_directory vendor_path
      create_directory aem_binary_path
      create_directory aem_instances_path
      create_directory aem_instances_author_path
      create_directory aem_instances_publish_path

      exit 0
    end

    def self.start(instance="all")

      if(instance == "all")
        puts 'starting author instance ...'
        puts 'starting publish instance ...'
      elsif(instance == "author")
        puts 'starting author instance ...'
      elsif(instance == "publish" || instance == "publisher")
        puts 'starting publisher instance ...'
      else
        Aemninja::Helpers.usage_start
      end
      exit 0
    end

    def self.create_directory(name)
      puts 'create ' + name
      FileUtils.mkdir_p name
    end
    def self.create_file(name)
      puts 'create ' + name
      FileUtils.touch name
    end

    
    def self.author
      Aemninja::Helpers.usage unless File.directory?(AEM_BINARY_PATH)

      #puts 'checking ' + AEM_INSTANCES_AUTHOR_BINARY
      if File.exists?(AEM_INSTANCES_AUTHOR_BINARY)
        #puts 'checking ' + AEM_INSTANCES_AUTHOR_LICENSE
        if File.exists?(AEM_INSTANCES_AUTHOR_LICENSE)
          # java -Xmx2048m -XX:MaxPermSize=512M -Djava.awt.headless=true  -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=30302 -jar aem-author-p4502.jar
          puts 'starting AEM author instance - ' + AEM_INSTANCES_AUTHOR_BINARY
        else
          puts "AEM License (license.properties) not found!"
          exit 1
        end
      else
        #puts 'checking ' + AEM_BINARY_FILE
        if File.exists?(AEM_BINARY_FILE)
          puts 'copying AEM author instance ' + AEM_BINARY_FILE + " -> " + AEM_INSTANCES_AUTHOR_BINARY
          puts 'copying License file ' + AEM_BINARY_LICENSE_FILE + " -> " + AEM_INSTANCES_AUTHOR_LICENSE
          puts 'starting AEM author instance - ' + AEM_INSTANCES_AUTHOR_BINARY
        else
          puts 'No AEM runtime found!'
          puts 'Please add aem-author-p4502.jar and license.properties to ' + AEM_BINARY_PATH

          exit 1
        end
      end
      exit 0
    end

  end

  module Helpers
    def self.usage

      if( File.directory?(AEM_INSTANCES_PATH) || File.directory?(File.join(ROOT_PATH, AEM_INSTANCES_PATH)) )
        puts
        puts
       puts 'Usage'
        puts
        puts '  aemninja COMMAND [ARGS]'
        puts
        puts 'Available COMMANDs are'
        puts '  start [author, publisher, all]                # start author, publisher or both(default)'
        puts
        puts
        puts
      else
        puts
        puts
        puts 'Usage:'
        puts
        puts '  aemninja init                                 # creates "aemninja" base directory in the current directory, adds a line to .gitignore'
        puts
        puts
        puts
      end

      exit 1
    end
    def self.usage_start
      puts
      puts
      puts 'Usage'
      puts
      puts '  aemninja start [ARGS]'
      puts
      puts 'Available ARGS are'
      puts '  aemninja start [all]                            # default, starts author and publisher instance'
      puts '  aemninja start author                           # starts author instance'
      puts '  aemninja start publish[er]                      # starts publisher instance'
      puts
      puts
      puts

      exit 1
    end
  end
end
