FROM ubuntu:latest

RUN apt update \
    && apt install -y \
        default-jdk \
        unzip \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

ADD https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip \
    /tmp/android-tools.zip

RUN echo "87f6dcf41d4e642e37ba03cb2e387a542aa0bd73cb689a9e7152aad40a6e7a08 /tmp/android-tools.zip" \
    | sha256sum --check

ENV ANDROID_SDK_ROOT="/opt/android-sdk"

RUN mkdir -p "$ANDROID_SDK_ROOT" \
    && unzip -d "$ANDROID_SDK_ROOT/cmdline-tools/" /tmp/android-tools.zip \
    && mv "$ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools" "$ANDROID_SDK_ROOT/cmdline-tools/latest"

ENV PATH="$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin/"

RUN yes | sdkmanager --licenses
RUN mkdir $ANDROID_SDK_ROOT/platforms
RUN sdkmanager --install "platform-tools" "emulator"

ENV PATH="$PATH:$ANDROID_SDK_ROOT/platform-tools/"
