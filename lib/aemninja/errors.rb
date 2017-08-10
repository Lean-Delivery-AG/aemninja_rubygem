module Aemninja
  module Errors

    def self.not_a_file(path)
      puts 'ERROR: ' + path + ' is not a file!'
      exit 1
    end

    def self.does_not_exist(path)
      puts 'ERROR: ' + path + ' does not exist!'
      exit 2
    end
  end
end