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

  end
end