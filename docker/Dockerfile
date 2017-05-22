FROM ubuntu:latest

RUN apt-get update --fix-missing && apt-get -y upgrade &&\
apt-get install -y sudo curl wget unzip git
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - &&\
sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' &&\
sudo apt-get update &&\
sudo apt-get install -y google-chrome-unstable

RUN apt-get install -y ruby ruby-dev build-essential libxml2-dev libffi-dev libz-dev

RUN curl https://chromedriver.storage.googleapis.com/2.29/chromedriver_linux64.zip | funzip > /usr/local/bin/chromedriver && chmod +x /usr/local/bin/chromedriver

RUN addgroup --gid 1100 rspec
RUN adduser --disabled-password --disabled-login --gecos '' --uid 1100 --gid 1100 rspec

RUN gem install --no-ri --no-rdoc bundler

USER rspec
WORKDIR /home/rspec

ENV BUNDLE_PATH=/home/rspec/.gem
ENV GEM_PATH=/home/rspec/.gem
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/rspec/.gem/bin

RUN git clone https://github.com/graylog-labs/qa-frontend.git
WORKDIR /home/rspec/qa-frontend
RUN git checkout rspec
RUN bundle install
RUN touch local_env.rb

CMD ["rspec"]
