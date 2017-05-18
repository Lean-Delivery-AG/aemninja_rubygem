## Getting Started

1. Install AEMNinja at the command prompt:

        $ gem install aemninja

1. At the command prompt, create a new AEM application:

        $ aemninja new myapp
where "myapp" is the application name.
   
1. Copy your AEM Binary and License file into myapp/vendor/aem

        $ cp aem-author-p4502.jar myapp/vendor/aem


## Starting the AEM Server
Change into the application directory.

        $ cd myapp

### Author only

        $ aemninja author

### Publish only

        $ aemninja publish

### Author & Publish

        $ aemninja all
