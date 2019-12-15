require 'base64'
require 'json'
require 'rest-client'
require 'active_support/core_ext/hash'

module Aem
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
  #
  # returns adobe/aem6/sample/we.retail.download-1.0.8.zip
  #
  def self.list host="localhost:4502", user="admin", password="admin"
    # puts user
    # puts password
    # puts "#{user}:#{password}"
    auth = Base64.strict_encode64("#{user}:#{password}")
    # puts auth
    response_xml = RestClient.get "#{host}/crx/packmgr/service.jsp", {params: {cmd: 'ls'}, Authorization: "Basic #{auth}"}

    puts response_xml
  end

  def self.is_package_installed? host="localhost:4502", user="admin", password="admin", package
    auth = Base64.strict_encode64("#{user}:#{password}")

    response_xml = RestClient.get "#{host}/crx/packmgr/service.jsp", {params: {cmd: 'ls'}, Authorization: "Basic #{auth}"}

    response_hash = Hash.from_xml(response_xml.body)

    installed_packages = response_hash["crx"]["response"]["data"]["packages"]["package"]

    if ary = installed_packages.find { |h| h['downloadName'].include? package }
      result = ary['group'] + "/" + ary['downloadName']
    else
      result = nil
    end

    result
  end

  def self.uninstall host="localhost:4502", user="admin", password="admin", package
    auth = Base64.strict_encode64("#{user}:#{password}")
    request = RestClient::Request.new( 
        :method => :post,
        :url => "#{host}/crx/packmgr/service/.json/etc/packages/#{package}",
        :payload => {
            :cmd => 'uninstall'
        },
        :headers => {Authorization: "Basic #{auth}"}
    )
    response = request.execute

    JSON.parse(response)["success"]
  end

    def self.delete host="localhost:4502", user="admin", password="admin", package
      auth = Base64.strict_encode64("#{user}:#{password}")
      request = RestClient::Request.new( 
          :method => :post,
          :url => "#{host}/crx/packmgr/service/.json/etc/packages/#{package}",
          :payload => {
              :cmd => 'delete'
          },
          :headers => {Authorization: "Basic #{auth}"}
      )
      response = request.execute

      JSON.parse(response)["success"]
      
    end


  def self.install host="localhost:4502", user="admin", password="admin", package
    auth = Base64.strict_encode64("#{user}:#{password}")
    stripped_pkg = Aemninja::Helpers::remove_path_and_version_from package
    request = RestClient::Request.new( 
        :method => :post,
        :url => "@#{host}/crx/packmgr/service.jsp",
        :payload => {
            :multipart => true,
            :file => File.new(package, 'rb'),
            :name => stripped_pkg,
            :force => true,
            :install => true
        },
        :headers => {Authorization: "Basic #{auth}"}
    )
    response_xml = request.execute

    #response_hash = Hash.from_xml(response_xml.body)

    errors = response_xml.body.each_line.grep /^E/

    if errors.present?
      puts
      puts
      puts "  ERRORS:"
      puts errors
      puts
      return false
    elsif Hash.from_xml(response_xml.body)["crx"]["response"]["status"] == 'ok'
      return true
    else
      return false
    end

  end
end