#!/bin/bash

#### Download dependencies to downloads folder. ####
##
# * Android SDK
# * Flutter
# * Gradle
# * OpenJDK 8

cd ~/Downloads
wget https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
wget https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_v1.9.1+hotfix.2-stable.tar.xz
wget https://downloads.gradle-dn.com/distributions/gradle-5.6.2-bin.zip

sudo apt update
sudo apt install openjdk-8-jdk


#### Configure packages to the right directories ####

## Android SDK Tools
unzip sdk-tools-linux-4333796.zip
mkdir Android
mv tools/ Android/
sudo mv Android/ /usr/lib

## Flutter
tar xvf flutter_linux_v1.9.1+hotfix.2-stable.tar.xz
sudo mv flutter/ /usr/lib

## Gradle
unzip gradle-5.6.2-bin.zip
mkdir gradle
mv gradle-5.6.2/ gradle/
sudo mv gradle/ /opt/


#### Configure paths and add to .profile ####

## Android paths
echo \#### FLUTTER CONFIG AND DEPS \#### >> ~/.profile
echo \## ANDROID SDK >> ~/.profile
echo export ANDROID_HOME=/usr/lib/Android >> ~/.profile
echo export PATH=\$ANDROID_HOME/tools:\$PATH >> ~/.profile
echo export PATH=\$ANDROID_HOME/tools/bin:\$PATH >> ~/.profile
echo export PATH=\$ANDROID_HOME/platform-tools:\$PATH >> ~/.profile

echo export ANDROID_SDK_ROOT=/usr/lib/Android >> ~/.profile
echo export PATH=\$ANDROID_SDK_ROOT:\$PATH >> ~/.profile

## Flutter paths
echo \## FLUTTER TOOLS >> ~/.profile
echo export PATH=/usr/lib/flutter/bin:\$PATH >> ~/.profile

## Gradle paths
echo \## GRADLE >> ~/.profile
echo export PATH=/opt/gradle/gradle-5.6.2/bin:\$PATH >> ~/.profile


#### Setup for Android SDK and a test emulator device ####

# Configure flutter
flutter config --android-sdk /usr/lib/Android

# Getting images and build tools for emulator 
sdkmanager "system-images;android-29;google_apis;x86_64"
sdkmanager "platforms;android-29"
sdkmanager "platform-tools"
sdkmanager "patcher;v4"
sdkmanager "emulator"
sdkmanager "build-tools;29.0.2"

# Accept licenses
sdkmanager --licenses

# Create emulator device (Pixel phone)
avdmanager -s create avd -n pixel -k "system-images;android-29;google_apis;x86_64" -d 17


#### Check if all dependencies are found, and view list of emulated devices ####
flutter doctor -v
flutter emulators


#### NOTES ####

## Run "flutter emulator --launch pixel" to start the emulator. If this does not work, it might be a problem with virtualization.
## One possible solution:
##
## 1. sudo apt install qemu-kvm
## 2. sudo adduser $USER kvm
## 3. Logout or restart
