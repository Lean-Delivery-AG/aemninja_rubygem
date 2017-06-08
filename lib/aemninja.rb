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

      Aemninja::Helpers::create_directory ROOT_PATH
      Aemninja::Helpers::create_directory CONFIG_PATH
      Aemninja::Helpers::create_directory ENVIRONMENTS_PATH
      Aemninja::Helpers::create_file DEVELOPMENT_ENVIRONMENT_FILE
      Aemninja::Helpers::create_directory VENDOR_PATH
      Aemninja::Helpers::create_directory AEM_BINARY_PATH
      Aemninja::Helpers::create_directory AEM_INSTANCES_PATH
      Aemninja::Helpers::create_directory AEM_INSTANCES_AUTHOR_PATH
      Aemninja::Helpers::create_directory AEM_INSTANCES_PUBLISH_PATH


      puts "append " + AEM_INSTANCES_PATH + " to .gitignore"
      File.open('.gitignore', 'a') do |f|
        f.puts
        f.puts "# AEMNinja - Exclude AEM Author & Publisher Server directories"
        f.puts AEM_INSTANCES_PATH
      end


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
