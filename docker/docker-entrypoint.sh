#!/bin/sh

cd ~
git clone https://github.com/graylog-labs/qa-frontend.git
cd qa-frontend/ruby && git checkout rspec && bundle install

touch local_env.rb

rspec
