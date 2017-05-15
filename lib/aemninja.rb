require "aemninja/version"

module Aemninja
  class Commands
      def create_application_scaffold!(app_path, package_name)
        puts 'create ' + app_path
        Dir.mkdir app_path
        Dir.chdir app_path

        `mvn archetype:generate \
          -DarchetypeRepository=http://repo.adobe.com/nexus/content/groups/public/ \
          -DarchetypeGroupId=com.day.jcr.vault \
          -DarchetypeArtifactId=multimodule-content-package-archetype \
          -DarchetypeVersion=1.0.2 \
          -DgroupId=com.cs.smaco \
          -DartifactId=#{app_path} \
          -Dversion=1.0-SNAPSHOT \
          -Dpackage=#{package_name} \
          -DappsFolderName=#{app_path} \
          -DartifactName=#{app_path} \
          -DcqVersion="6.2" \
          -DpackageGroup="#{app_path}"`

        exit 0
      end
  end
end
