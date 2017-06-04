require "aemninja/version"
require "aemninja/helpers"
require "aemninja/usage"
require 'fileutils'

module Aemninja
  class Application

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

    def init!
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

      Aemninja::Helpers::create_directory config_path
      Aemninja::Helpers::create_directory environments_path
      Aemninja::Helpers::create_file development_environment_file
      Aemninja::Helpers::create_directory vendor_path
      Aemninja::Helpers::create_directory aem_binary_path
      Aemninja::Helpers::create_directory aem_instances_path
      Aemninja::Helpers::create_directory aem_instances_author_path
      Aemninja::Helpers::create_directory aem_instances_publish_path

      exit 0

    end

    def deploy!(environment='local')
      puts 'deploying to ' + environment

      exit 0
    end

    def start(instance="all")
      if(instance == "all")
        puts 'starting author instance ...'
        puts 'starting publish instance ...'
      elsif(instance == "author")
        puts 'starting author instance ...'
      elsif(instance == "publish" || instance == "publisher")
        puts 'starting publisher instance ...'
      else
        Aemninja::Usage.start
      end

      exit 0
    end

    def author
      Aemninja::Usage.init unless File.directory?(AEM_BINARY_PATH)

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

    def no_valid_command
      if( File.directory?(AEM_INSTANCES_PATH) || File.directory?(File.join(ROOT_PATH, AEM_INSTANCES_PATH)) )
        Aemninja::Usage.start
      else
        Aemninja::Usage.init
      end
    end

  end
end
