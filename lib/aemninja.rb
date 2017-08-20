require "aemninja/version"
require "aemninja/errors"
require "aemninja/helpers"
require "aemninja/usage"
require 'fileutils'
require 'RestClient'
require 'active_support/core_ext/hash'

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
        Aemninja::Errors::already_initialized(ROOT_PATH)
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
          #puts 'deploy package ' + pkg +  ' to ' + environment

          installed_package_name = is_package_installed? pkg

          if installed_package_name != nil
            puts "uninstall existing package " + installed_package_name + " from " + environment
          end

          # UNINSTALL
          #   request = RestClient::Request.new( 
          #       :method => :post,
          #       :url => 'admin:admin@localhost:4502/crx/packmgr/service/.json/etc/packages/adobe/aem6/sample/we.retail.download-1.0.8.zip',
          #       :payload => {
          #           :cmd => 'uninstall'
          #       })
          #   response = request.execute

          # DELETE
          #   request = RestClient::Request.new( 
          #       :method => :post,
          #       :url => 'admin:admin@localhost:4502/crx/packmgr/service/.json/etc/packages/adobe/aem6/sample/we.retail.download-1.0.8.zip',
          #       :payload => {
          #           :cmd => 'delete'
          #       })
          #   response = request.execute

          # INSTALL PACKAGE
          # request = RestClient::Request.new( 
          #     :method => :post,
          #     :url => 'admin:admin@localhost:4502/crx/packmgr/service.jsp',
          #     :payload => {
          #         :multipart => true,
          #         :file => File.new('we.retail.download-1.0.8.zip', 'rb'),
          #         :name => 'we.retail.download',
          #         :force => true,
          #         :install => true
          #     })
          # response = request.execute


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


    # is_package_installed?
    # RestClient.get 'admin:admin@localhost:4502/crx/packmgr/service.jsp', {params: {cmd: 'ls'}}

    # group>adobe/aem6/sample</group>\n
    # <downloadName>cq-geometrixx-outdoors-ugc-pkg-5.8.18.zip</downloadName>\n


    # <crx version="1.4.1" user="admin" workspace="crx.default">
    # <request>
    #   <param name="cmd" value="ls"/>
    # </request>
    # <response>
    #   <data>
    #     <packages>
    #       <package>
    #         <group>Adobe/granite</group>
    #         <name>com.adobe.granite.httpcache.content</name>
    #         <version>1.0.2</version>
    #         <downloadName>com.adobe.granite.httpcache.content-1.0.2.zip</downloadName>
    #         <size>13323</size>
    #         <created>Tue, 25 Feb 2014 11:40:56 +0100</created>
    #         <createdBy>Adobe</createdBy>
    #         <lastModified></lastModified>
    #         <lastModifiedBy>null</lastModifiedBy>
    #         <lastUnpacked>Thu, 10 Aug 2017 13:42:23 +0200</lastUnpacked>
    #         <lastUnpackedBy>admin</lastUnpackedBy>
    #       </package>
    def is_package_installed? package


      stripped_pkg = URI(package).path.split('/').last.split(/[0-9]/)[0]

      response_xml = RestClient.get 'admin:admin@localhost:4502/crx/packmgr/service.jsp', {params: {cmd: 'ls'}}

      response_hash = Hash.from_xml(response_xml.body)

      installed_packages = response_hash["crx"]["response"]["data"]["packages"]["package"]

      if h = installed_packages.find { |h| h['downloadName'].include? stripped_pkg }
        result = h['downloadName']
      else
        result = nil
      end

      result
    end

  end
end
