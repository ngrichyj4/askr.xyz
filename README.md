# Getting started

## Create heroku account
Then, I'll need your email to add you as a collaborator on the instance.

## Install Heroku toolbelt, for your platform
https://toolbelt.heroku.com/

## Configure heroku remote in Git, to be able to push to heroku
heroku git:remote -a askr-staging

## Verify settings
git remote -v

## To push to any code changes to heroku, do
git add .
git commit -m "..changes...."
git push heroku

## App url, we can set main web url to point here using CNAME later.
https://askr-staging.herokuapp.com