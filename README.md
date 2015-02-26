# FOVe
Rainfactory Crowdfunding Campaign site

*CircleCi Status, Master Branch*
[![Circle CI](https://circleci.com/gh/monsoonco/FOVe/tree/master.svg?style=svg&circle-token=7d0f2a543ee44c20ae9e8194a707677178402f8a)](https://circleci.com/gh/monsoonco/FOVe/tree/master)

*CirclCi Status, Develop Branch*
[![Circle CI](https://circleci.com/gh/monsoonco/FOVe/tree/develop.svg?style=svg&circle-token=00455eff16cb89334e05788a3ddd300ec798e061)](https://circleci.com/gh/monsoonco/FOVe/tree/develop)

**Staging Urls**
* *S3 Bucket*: staging-fove.s3-website-us-west-1.amazonaws.com
* *Cloudfront*: didpsqvujxdlo.cloudfront.net

**Production Urls**
* *S3 Bucket*: production-fove.s3-website-us-west-1.amazonaws.com
* *Cloudfront*: d2rbbz6hr34o3y.cloudfront.net

#####  Ingredients
* AWS S3 + Cloudfront
* Middleman
* Boostrap-SASS
* Angular
* Continuous integration with CircleCI
* Cross browser testing with Browserstack + Cucumber + Capybara + Selenium-Webdriver

##### Local Setup

1. **Clone this repository**

  <code> git clone  git@github.com:monsoonco/FOVe.git project-name </code>

2. The **develop** branch represents **staging**.  The **master** branch represents **production**. Everyone should begin their work by creating a uniquely named branch off of the develop branch.  **Do NOT make any direct changes/pushes to the develop or master branch.**

  <code> git checkout -b develop origin/develop </code>

  You should see that you're working off the develop branch now.

  <code> git checkout -b your-local-branch-name </code>

3. **Bundle Gems**

  <code> bundle install </code>

4. **Start a local web server running at: http://localhost:4567/**

  <code> bundle exec middleman server </code>

5. **Compile files**

   <code> bundle exec middleman build </code>

6. **We will be using CircleCI for contiuous integration and deployment to AWS**.  When you merge your branch into develop, the staging site and AWS staging bucket will automatically be updated.  Similarly, when you merge the develop branch into the master branch, the production site and AWS production bucket will be updated.

7. **Setup your CircleCI**
   * Setup Github account with Circle CI (circleci.com)
   * Go to 'Add Projects' and add **FOVe**
   * Watch CircleCI deploy your code!  :D

8. **If you need to experiment with pushing assets to AWS S3 locally,** you can do the following:
   * Create an aws.yml file at the root of the application.
   * Add environmental variables from AWS LastPass notes to aws.yml
   * Uncomment  <code> ENV = YAML::load(File.open('aws.yml')) </code> in config.rb
   * Run these commands to push assets to AWS staging-swyp bucket

   <code> bundle exec middleman build --verbose </code>

   <code> bundle exec middleman s3_sync --bucket=staging-fove </code>

   <code> STAGING_CLOUDFRONT_DISTRIBUTION_ID= bundle exec middleman invalidate </code>

## Local Cucumber Testing

1. Install Selenium IDE, install add-ons by opening with Firefox.  Follow instructions here:

  * http://www.seleniumhq.org/docs/02_selenium_ide.jsp#installing-the-ide

2. Enable access to http://0.0.0.0:4567

   <code> bundle exec middleman </code>

2. Run cucumber.  But you have to say "I say tomato, you say tomato" first.

   <code> rake i_say tomato=tomahto </code>


## Multiple Browser and Device Automated Testing

We are doing cross browser testing and device testing with Browserstack + Cucumber + Capybara + Selenium-Webdriver

The browsers and devices we are testing are listed in browser.json at the root of this application.
Everytime CircleCi will run a build, the updated staging url will be tested.

You can also run tests from your console:

1. To test all browsers and devices at once listed in browsers.json, run the following rake task and Browserstack configuration variables from LastPass:

   <code> rake cross_browser BS_USERNAME=XXXXX BS_AUTHKEY=XXXXXXXXX </code>

2. To test only one browser or device one at a time, specify the main key name from browsers.json:

   For a Google Chrome browser test:
   <code> rake cross_browser:chrome BS_USERNAME=XXXXX BS_AUTHKEY=XXXXXXXXX </code>

   For an iPhone 6 mobile Safari test:
   <code> rake cross_browser:iphone_6 BS_USERNAME=XXXXX BS_AUTHKEY=XXXXXXXXX </code>