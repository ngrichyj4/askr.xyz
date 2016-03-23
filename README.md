# Dev environment
## One-time: Setup rails-dev-box
* Install Vagrant
* Install Virtualbox
* Clone askr.xyz on gitlab
* Run `vagrant up`

## Every time: connect to vagrant box
* `vagrant ssh`

## Every time: setup and run Rails
* `cd /vagrant`
* `bundle`
* `rake db:migrate`
* `rails s`

# Deploying

## Create heroku account
Then, I'll need your email to add you as a collaborator on the instance.

## Install Heroku toolbelt, for your platform
https://toolbelt.heroku.com/

## Configure heroku remote in Git, to be able to push to heroku
heroku git:remote -a askr-staging

## Verify settings
git remote -v

## To push to any code changes to heroku, do
* git add .
* git commit -m "..changes...."
* git push heroku

## App url, we can set main web url to point here using CNAME later.
https://askr-staging.herokuapp.com
