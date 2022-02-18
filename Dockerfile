FROM openjdk:11

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]

ENV ANDROID_COMPILE_SDK="30"        \
    ANDROID_BUILD_TOOLS="30.0.3"

ENV ANDROID_HOME=/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/platform-tools/:${ANDROID_NDK_HOME}${ANDROID_HOME}/cmdline-tools/tools/bin/

RUN apt-get --quiet update --yes
RUN apt-get --quiet install --yes wget tar unzip lib32stdc++6 lib32z1
RUN wget --quiet --output-document=android-sdk.zip https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip
RUN unzip -d android-sdk-linux android-sdk.zip
RUN cd android-sdk-linux/cmdline-tools \
    && mkdir tools \
    && mv -i NOTICE.txt tools \
    && mv -i bin tools \
    && mv -i lib tools \
    && mv -i source.properties tools
RUN echo y | sdkmanager --install "platforms;android-${ANDROID_COMPILE_SDK}"
RUN echo y | sdkmanager --install "platform-tools"
RUN echo y | sdkmanager --install "build-tools;${ANDROID_BUILD_TOOLS}"
RUN yes | sdkmanager --licenses
RUN apt-get install ruby-full --yes
RUN apt-get install build-essential --yes
RUN gem install bundler



