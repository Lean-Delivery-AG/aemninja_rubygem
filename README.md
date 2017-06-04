## Getting Started

1. Install AEMNinja at the command prompt:

        $ gem install aemninja

1. At the command prompt, create a new AEM application:

        $ aemninja new myapp
where "myapp" is the application name.
   
1. Copy your AEM Binary and License file into myapp/vendor/aem

        $ cp aem-author-p4502.jar myapp/vendor/aem
        $ cp license.properties myapp/vendor/aem


## Starting the development AEM Server on your local machine

Change into the application directory.

        $ cd myapp

### Author & Publish

        $ aemninja all

### Author only

        $ aemninja author

### Publish only

        $ aemninja publisher

