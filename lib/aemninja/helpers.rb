require 'uri'

module Aemninja
  module Helpers

    def self.create_directory(name)
      puts 'create ' + name
      FileUtils.mkdir_p name
    end

    def self.create_file(name)
      puts 'create ' + name
      FileUtils.touch name
    end

    def self.remove_path_from package
      URI(package).path.split('/').last
    end

    def self.remove_version_from package
      package.split(/[0-9]/)[0]
    end

    def self.remove_path_and_version_from package
      package_without_path = remove_path_from package
      remove_version_from package_without_path
    end

  end
end