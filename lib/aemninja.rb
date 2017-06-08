require "aemninja/version"
require "aemninja/helpers"
require "aemninja/usage"
require 'fileutils'

module Aemninja
  class Application

    ROOT_PATH="aemninja"
    CONFIG_PATH = File.join(ROOT_PATH, "config")
    ENVIRONMENTS_PATH = File.join(CONFIG_PATH, "environments")
    DEVELOPMENT_ENVIRONMENT_FILE = File.join(ENVIRONMENTS_PATH, "development.rb")

    VENDOR_PATH = File.join(ROOT_PATH, "vendor")
    AEM_BINARY_PATH = File.join(VENDOR_PATH, "aem")
    AEM_BINARY_LICENSE_FILE = File.join(AEM_BINARY_PATH, "license.properties")

    AEM_INSTANCES_PATH = File.join(ROOT_PATH, "aem_instances")
    AEM_INSTANCES_AUTHOR_PATH = File.join(AEM_INSTANCES_PATH, "author")
    AEM_INSTANCES_PUBLISH_PATH = File.join(AEM_INSTANCES_PATH, "publish")
    AEM_INSTANCES_AUTHOR_BINARY_NAME = "aem-author-p4502.jar"
    AEM_INSTANCES_AUTHOR_BINARY = File.join(AEM_INSTANCES_AUTHOR_PATH, AEM_INSTANCES_AUTHOR_BINARY_NAME)
    AEM_INSTANCES_AUTHOR_LICENSE = File.join(AEM_INSTANCES_AUTHOR_PATH, "license.properties")
    AEM_INSTANCES_PUBLISH_BINARY_NAME = "aem-publish-p4503.jar"
    AEM_INSTANCES_PUBLISH_BINARY = File.join(AEM_INSTANCES_PUBLISH_PATH, AEM_INSTANCES_PUBLISH_BINARY_NAME)
    AEM_INSTANCES_PUBLISH_LICENSE = File.join(AEM_INSTANCES_PUBLISH_PATH, "license.properties")

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

        start_author
        start_publisher

      elsif(instance == "author")

        start_author

      elsif(instance == "publish" || instance == "publisher")

        start_publisher

      else

        Aemninja::Usage.start

      end

      exit 0
    end

    def start_author
      puts 'starting AEM author instance ...'
      if not File.exists? AEM_INSTANCES_AUTHOR_BINARY
        puts "Adobe Experience Manager JAR File '" + AEM_INSTANCES_AUTHOR_BINARY + "' not found!"

        exit 1
      end
      
      if not File.exists? AEM_INSTANCES_AUTHOR_LICENSE
        puts "AEM License (" + AEM_INSTANCES_AUTHOR_LICENSE + ") not found in" + AEM_INSTANCES_AUTHOR_PATH

        exit 1
      end

      Dir.chdir(AEM_INSTANCES_AUTHOR_PATH) do
        #system "rails server &"
        pid = spawn 'java -server -Xmx1024m -Djava.awt.headless=true -jar ' + AEM_INSTANCES_AUTHOR_BINARY_NAME
        puts 'PID: ' + pid.to_s
      end

    end

    def start_publisher
      puts 'starting AEM publisher instance ...'
      if not File.exists? AEM_INSTANCES_PUBLISH_BINARY
        puts "Adobe Experience Manager JAR File '" + AEM_INSTANCES_PUBLISH_BINARY + "' not found!"

        exit 1
      end
      
      if not File.exists? AEM_INSTANCES_PUBLISH_LICENSE
        puts "AEM License (" + AEM_INSTANCES_PUBLISH_LICENSE + ") not found in" + AEM_INSTANCES_PUBLISH_PATH

        exit 1
      end

      Dir.chdir(AEM_INSTANCES_PUBLISH_PATH) do
        #system "rails server &"
        pid = spawn 'java -server -Xmx1024m -Djava.awt.headless=true -jar ' + AEM_INSTANCES_PUBLISH_BINARY_NAME
        puts 'PID: ' + pid.to_s
      end

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
