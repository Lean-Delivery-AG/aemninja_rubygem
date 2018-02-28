## Getting Started

1. Install AEMNinja at the command prompt:

        $ gem install aemninja

1. In your project directory, initialize aemninja:

        $ cd my_aem_project
        $ aemninja init
        create .aemninja
		create .aemninja/config
		create .aemninja/config/environments
		create .aemninja/config/environments/local.rb
		create .aemninja/config/environments/staging.rb
		create .aemninja/config/environments/production.rb


# Deployment

## Local 
		$ aemninja deploy apps/target/your-magic-project.zip

## Staging
		$ aemninja deploy apps/target/your-magic-project.zip staging

## Production
		$ aemninja deploy apps/target/your-magic-project.zip production


# FAQ
## But how does it now the details about my environments?

 * .aemninja/config/environments/local.rb
 * .aemninja/config/environments/staging.rb
 * .aemninja/config/environments/production.rb

## Can I add additional environments?

Sure! It's as easy as adding another config file to the environments directory. The name of the file can then be used with aemninja.

### New Environment called 'qa'
1. Copy existing config file

		$ cp .aemninja/config/environments/local.rb .aemninja/config/environments/qa.rb 

2. Change the configuration to match your qa environment

		Aemninja.configure do |config|
  		  config.instances = {
    	    author: { host: "qa-author.example.com", user: "admin", password: "secret_password"},
    	    publish: { host: "qa-publish.example.com", user: "admin", password: "secret_password"}
  		  }
		end

2. Deploy

		$ aemninja deploy apps/target/your-magic-project.zip qa

