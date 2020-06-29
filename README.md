# Voyage a.k.a the HeadwayRailsTemplate

A template for easily building rails applications used by and for Headway developers. It takes Rails to the next level by increasing our use of convention over configuration and adds sane defaults to quickly get your app up to speed.

Some highlights of Voyage include:

1. API Endpoints that utilize JSON::API compliant json responses
1. Administrate so that we can manage data together quickly and easily
1. Static page management to build out static pages quickly and easily

Batten down the hatches because you've never seen Rails development this fast or easy.

## Prerequisites

The following must be installed:

1. Ruby 2.6.3
1. Postgres
1. Redis

## Set Sail (Development)

Clone the stimulus_cable_ready repo from GitHub

`git clone https://github.com/headwayio/stimulus_cable_ready.git ~/my/project/dir`

Bootstrap your application:

```shell
% ./bin/voyage
```

This renames stimulus_cable_ready and HeadwayRailTemplate in all places to be your_app and YourApp where appropriate.

Run this setup script to set up your machine
with the necessary dependencies to run and test this app:


Setup a gemset with RVM.

```shell
% rvm use ruby-2.6.3@my_app_name --create
```

Now let's run the setup script.

```shell
% ./bin/setup
```

The setup script installs bundler, and installs gems, then it runs the rake task 'dev:prime' which sets up your database (create, schema:load, and seed). This action is destructive so be a bit careful. The seeds by default will destroy all users and create one admin user and 10 users in the database.

```
  admin@example.com -> asdfjkl123
  user{1-10}@example.com -> asdfjkl123
```

### Seeded Data

Commonly one must seed the database with data for different environments. Included is a basic `db/seeds.rb` file with some starter seeds. Open up `db/seeds.rb` and `lib/seeders.rb` to see how to add your own seeds.

## Developing with Voyage

### Authentication

The Devise gem is used for authentication.
https://github.com/heartcombo/devise

By default Users are set up to be:
```
:invitable, :database_authenticatable, :registerable,
:recoverable, :rememberable, :trackable, :validatable,
:token_authenticatable
```
Devise is used through out the codebase for authentication against specific controller actions and is set up to use Cookie based auth for server rendered routes. For the API endpoints we use token based authentication and require that clients pass:

1. `X-CLIENT-TOKEN`
1. `X-CLIENT-EMAIL`

as headers for authentication.

Tokens can be generated by "signing in" (POST to api/v1/authentication_tokens) which directs to the Devise sessions controller and generates a token with the Tiddle gem. You also receive a token back in the metadata of a successful user creation.

Tiddle https://github.com/adamniedzielski/tiddle

### Authorization

Voyage uses CanCanCan and Canard to authorize user action. `ApplicationController` defines the `check_authorization` method for non-devise non-high voltage controllers. If you want to skip authorization for a specific method in a controller, the following method can be used: `skip_authorization_check`

Abilities are defined in:

`app/abilites/my_model_which_is_database_authenticatables.rb`

For example the User abilities are defined in:

`app/abilities/users.rb`

See Canard and CanCanCan for more on defining abilities:

https://github.com/CanCanCommunity/cancancan
https://github.com/james2m/canard

### API

Looking closer in the spyglass now you'll see a plethora of controller endpoints already exist. Though if you open up a controller you'll notice their conspicuously empty. We leverage Rails conventions heavily for API endpoints and encourage you to do the same.
To make this happen we utilize one gem quite heavily:

jsonapi-utils

Some more info on the JSON API as well as more documentation on gems built into jsonapi-utils and Rails can be found here:

jsonapi-renderer
https://github.com/jsonapi-rb/jsonapi-renderer

jsonapi-resources
https://github.com/cerebris/jsonapi-resources

To make this work we define a base_api_controller that handles some of the basics of our authz and authn. But the key here is that the `JSONAPI::Utils` and `JSONAPI::ActsAsResourceController` modules are included which by default set our controllers to infer a resource, consume and easily tranform JSON api spec'ed json requests, and respond with JSON api spec'ed json responses.

1. To use the attributes in a controller action you can utilize the `resource_params`
2. An example of a JSON API Resource can be seen in the `app/resources/api/v1/user_resource.rb` this resource infers it's model based on it's name, `app/models/user.rb`. This resource is then inferred by the `api/v1/users_controller.rb`
3. Responses by default use the inferred resource (and therefore the inferred model) as `jsonapi_render json: my_inferred_model`

For each model/controller combination you want to expose in your API you'll need a corresponding resource. For example we have the `api/v1/user_resource.rb` file that defines the `Api::V1::UserResource` resources are required for the controller to properly respond with a valid response.

Authorization is still handled by Canard and CanCanCan, you can see the details of this in `api/v1/base_resource.rb` which show how we apply abilities through to the individual resources. If your permissions are handled properly by CanCanCan you don't need to worry about your API endpoints responding with the wrong data.

### Seaworthiness (Testing)

Voyage comes out of the box with lots of tests and great test coverage.

We use Rspec for unit testing and our test coverage is handled by Simplecov.

Testing strategy:

1. Unit test models, resources, services, POROs, and jobs.
1. Request specs for controllers especially our API endpoints.
1. Feature specs for "happy path" testing important parts of our codebase.

We use Cucumber and Capybara for feature specs and run our specs against the Selenium/ChromeDriver in chrome as we find that combination to be the most consistent. Using Cucumber we often write Gherkin style feature specs. Though we have no issues leveraging Capybara directly with Rspec if that's what floats your boat.

### Captains Log (Administrate)

There is no easier way to set up admin dashboards than by using Administrate.

Voyage leverages administrate to handle all the admin dashboard creation.

We already have you started by including dashboards wired up for Users, Addresses, Images, Attachments, and Authentication Tokens.

Dashboards are defined in `app/dashboards` see `app/dashboards/user_dashboard.rb` for an example. The views for dashboards are generated but you can override those and we have included some sensible overrides in `app/views/admins`.

You must be a signed in as a User with the `admin` role to see the admin dashboard. To update a User to be an admin you can easily do: `User.find_by(email: 'my_email@example.com').update!(roles: [:admin])`.

### Background Jobs

Voyage requires someone to swab the poopdeck when no one else is watching. We :heart: sidekiq and we're betting you do too. Voyage is setup by default for ActiveJob to leverage Sidekiq. So you can start using Sidekiq straight away by following ActiveJob conventions. You can also write jobs in `app/jobs` and calling those jobs with `MyJob.perform_later` will enqueue those jobs with Sidekiq.

For Sidekiq to run locally you'll need to have Redis installed and running. Then all you need to do is set the `REDIS_URL` in the .env file. Restart the server and run `bundle exec sidekiq` and sidekiq should start to consume jobs.

On Heroku you need to ensure to provision a Heroku Redis instance and then restart your dynos and add a dyno to the workers. Jobs should start to be executed at this point.

### Rubocop

Take a look at the `.rubocop.yml` file to see what styles are being enforced.

### Static Pages

The HighVoltage gem is used.

https://github.com/thoughtbot/high_voltage

### Annotations

Model & spec files are automatically annotated each time `rake db:migrate` is run.

https://github.com/brentgreeff/annotate

### Push Notifications

If you're building an API for a native client, we by default include some goodies for working with push notifications. Check out that documentation here:

See https://www.notion.so/hdwy/Push-Notifications-eafb97c6a9e6438ea364efc086cbf7ca

## Maiden Voyage (Heroku Setup)
Almost all voyages start on Heroku and to get up and running on heroku with Voyage you'll need to set the following config vars:

Heroku Config Vars

    heroku config:set FORCE_SEED=1
    heroku config:set REDIS_URL=''
    heroku config:set SEGMENT_ANALYTICS_RUBY_KEY=''
    heroku config:set SMTP_ADDRESS=''
    heroku config:set SMTP_DOMAIN=''
    heroku config:set SMTP_PASSWORD=''
    heroku config:set SMTP_USERNAME=''
    heroku config:set SIDEKIQ_USERNAME=''
    heroku config:set SIDEKIQ_PASSWORD=''
    heroku config:set APPLICATION_HOST='stimulus_cable_ready.headway.io'

There is a default Procfile with the following processes:

```
    web
    worker
    rpush
    release
```

### Deploying to Heroku

If you have previously run the `./bin/setup` script and setup your heroku app as a `git remote` and the heroku app is named the same as your application. You can deploy to staging and production with:

    % ./bin/deploy staging
    % ./bin/deploy production

These scripts run migrations and restart the app. So modify these scripts if you do not want to migrate and restart by default.

# Help us keep Voyage up to date

To keep our Rails template up to date with the latest libraries and security fixes:

1. Run `bundle update`.
2. Review recent releases of https://github.com/thoughtbot/suspenders/releases for changes of interest.
3. Check with team for relevant changes from other projects to bring into our template.
4. Run the test suite to ensure nothing's broken.
