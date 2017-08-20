module Aemninja
  module Usage

    def self.commands
        puts
        puts 'Usage:'
        puts '  aemninja COMMAND [ARGS]'
        puts
        puts 'Available COMMANDs:'
        puts '  init                                         # creates ".aemninja" base directory'
        puts '  deploy                                       # deploys package to local or remote AEM instances'
        puts
        puts
        puts
    end

    def self.deploy
      puts
      puts
      puts 'Usage'
      puts '  aemninja deploy PATH_TO_PACKAGE [ENVIRONMENT]'
      puts
      puts 'Available ARGS are'
      puts '  aemninja deploy [local]                        # default, deploys to the AEM instances configured in .aemninja/config/environments/local.rb'
      puts '  aemninja deploy staging                        # deploys to the AEM instances configured in .aemninja/config/environments/staging.rb'
      puts '  aemninja deploy production                     # deploys to the AEM instances configured in .aemninja/config/environments/production.rb'
      puts
      puts
      puts

      exit 1
    end

  end
end
