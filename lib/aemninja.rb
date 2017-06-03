require "aemninja/version"
require 'fileutils'

module Aemninja
  CONFIG_PATH = "config"
  ENVIRONMENTS_PATH = CONFIG_PATH + "/environments"
  DEVELOPMENT_ENVIRONMENT_FILE = ENVIRONMENTS_PATH + "/development.rb"

  VENDOR_PATH = "vendor"
  AEM_BINARY_PATH = VENDOR_PATH + "/aem"
  AEM_BINARY_FILE = AEM_BINARY_PATH + "/aem-author-p4502.jar"
  AEM_BINARY_LICENSE_FILE = AEM_BINARY_PATH + "/license.properties"

  AEM_INSTANCES_PATH = "aem_instances"
  AEM_INSTANCES_AUTHOR_PATH = AEM_INSTANCES_PATH + "/" + "author"
  AEM_INSTANCES_PUBLISH_PATH = AEM_INSTANCES_PATH + "/" + "publish"
  AEM_INSTANCES_AUTHOR_BINARY = AEM_INSTANCES_AUTHOR_PATH + "/" + "aem-author-p4502.jar"
  AEM_INSTANCES_AUTHOR_LICENSE = AEM_INSTANCES_AUTHOR_PATH + "/" + "license.properties"
  AEM_INSTANCES_PUBLISH_BINARY = AEM_INSTANCES_AUTHOR_PATH + "/" + "aem-publish-p4503.jar"
  AEM_INSTANCES_PUBLISH_LICENSE = AEM_INSTANCES_AUTHOR_PATH + "/" + "license.properties"

  module Commands
    def self.deploy!(environment='local')
      puts 'deploying to ' + environment

      exit 0
    end
    def self.new!(app_path)
      config_path                  = app_path + "/" + CONFIG_PATH
      environments_path            = app_path + "/" + ENVIRONMENTS_PATH
      development_environment_file = app_path + "/" + DEVELOPMENT_ENVIRONMENT_FILE
      vendor_path                  = app_path + "/" + VENDOR_PATH
      aem_binary_path              = app_path + "/" + AEM_BINARY_PATH
      aem_instances_path           = app_path + "/" + AEM_INSTANCES_PATH
      aem_instances_author_path    = app_path + "/" + AEM_INSTANCES_AUTHOR_PATH
      aem_instances_publish_path   = app_path + "/" + AEM_INSTANCES_PUBLISH_PATH

      create_directory app_path
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

    def self.publish
      Aemninja::Helpers.usage unless File.directory?(AEM_BINARY_PATH)
      puts 'starting AEM publish instance - ' + AEM_BINARY_PATH

      exit 0
    end

    def self.all
      Aemninja::Helpers.usage unless File.directory?(AEM_BINARY_PATH)
      puts 'starting AEM author & publish instance - ' + AEM_BINARY_PATH

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

  end

  module Helpers 
    def self.usage
      puts 'Usage:'
      puts '  aemninja new APP_PATH'
  
      exit 1
    end
  end
end
