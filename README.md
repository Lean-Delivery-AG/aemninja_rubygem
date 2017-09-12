## Getting Started

1. Install AEMNinja at the command prompt:

        $ gem install aemninja

1. At the command prompt, initialize aemninja:

        $ aemninja init


# Deployment

## Local 
aemninja deploy apps/target/your-magic-project.zip

## Staging
aemninja deploy apps/target/your-magic-project.zip staging

## Production
aemninja deploy apps/target/your-magic-project.zip production


But how does it now the details about my environments?

.aemninja/config/environments/local.rb
.aemninja/config/environments/staging.rb
.aemninja/config/environments/production.rb
author {...}

## Can I addadditional environments?

Sure! It's as easy as adding another config file to the environments directory. The name of the file can then be used with aemninja.

### New Environment called 'qa'
1. Copy existing config file
cp .aemninja/config/environments/local.rb .aemninja/config/environments/qa.rb 

2. Change the configuration to match your qa environment
