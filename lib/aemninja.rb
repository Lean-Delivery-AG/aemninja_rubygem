require "aemninja/version"

module Aemninja
  module Commands
    def self.deploy!(environment='local')
      puts 'deploying to ' + environment

      exit 0
    end
    def self.new!(app_path)
      environments_path   = app_path + "/environments"
      development         = environments_path + "/development.rb"
      staging             = environments_path + "/staging.rb"
      production          = environments_path + "/production.rb"

      puts 'creating ' + app_path
      `mkdir -p #{app_path}`


      puts 'creating ' + environments_path
      `mkdir -p #{environments_path}`

      puts 'creating ' + development
      `touch #{development}`

      puts 'creating ' + staging
      `touch #{staging}`

      puts 'creating ' + production
      `touch #{production}`
      exit 0
    end
  end

  module Helpers 
    def self.usage
      puts 'Usage:'
      puts '  aemninja new APP_PATH'
  
      exit 1
    end
  end
end
