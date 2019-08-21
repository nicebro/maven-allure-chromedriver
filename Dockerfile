FROM maven:3.6.0-jdk-11
USER root

# Google Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
	&& echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
	&& apt-get update -qqy \
	&& apt-get -qqy install google-chrome-stable \
	&& rm /etc/apt/sources.list.d/google-chrome.list \
	&& rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
	&& sed -i 's/"$HERE\/chrome"/"$HERE\/chrome" --no-sandbox/g' /opt/google/chrome/google-chrome

# Installing necessary packages
RUN apt-get update \
     && apt-get install -y --no-install-recommends \
          vim \
          procps \
          xvfb libxi6 libgconf-2-4 \
          libnss3-tools \
          tar \
     && apt-get clean \
     && rm -rf /var/lib/apt/lists/*

# ChromeDriver
ARG CHROME_DRIVER_VERSION=2.43
RUN wget --no-verbose -O /tmp/chromedriver_linux64.zip https://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip \
	&& rm -rf /opt/chromedriver \
	&& unzip /tmp/chromedriver_linux64.zip -d /opt \
	&& rm /tmp/chromedriver_linux64.zip \
	&& mv /opt/chromedriver /opt/chromedriver-$CHROME_DRIVER_VERSION \
	&& chmod 755 /opt/chromedriver-$CHROME_DRIVER_VERSION \
	&& ln -fs /opt/chromedriver-$CHROME_DRIVER_VERSION /usr/bin/chromedriver

WORKDIR /
RUN wget https://dl.bintray.com/qameta/generic/io/qameta/allure/allure/2.7.0/allure-2.7.0.tgz \
    && tar -xvf allure-2.7.0.tgz \
    && chmod -R +x /allure-2.7.0/bin
