module Aemninja
  module Usage

    def self.init
        puts
        puts
        puts 'Usage:'
        puts
        puts '  aemninja init                                 # creates "aemninja" base directory in the current directory, adds a line to .gitignore'
        puts
        puts
        puts

      exit 1
    end

    def self.commands
        puts
        puts
        puts 'Usage'
        puts
        puts '  aemninja COMMAND [ARGS]'
        puts
        puts 'Available COMMANDs are'
        puts '  start [author, publisher, all]                # start author, publisher or both(default)'
        puts
        puts
        puts
    end

    def self.start
      puts
      puts
      puts 'Usage'
      puts
      puts '  aemninja start [ARGS]'
      puts
      puts 'Available ARGS are'
      puts '  aemninja start [all]                            # default, starts author and publisher instance'
      puts '  aemninja start author                           # starts author instance'
      puts '  aemninja start publish[er]                      # starts publisher instance'
      puts
      puts
      puts

      exit 1
    end

  end
end
