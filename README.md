# ASCII-Nobeta
ASCII Nobeta is a small application that can generate/display ASCII Art with images.
It also supports generate/display ASCII Art with .txt files.
This application mainly use Ruby on Rails for the server side, with Jquery and Bootstrap to generate/display the result.
Demonstration can be found here: https://ascii-nobeta.herokuapp.com
Please feel free to take a look.

# Installation
To install this application on your localhost, you will need to install Ruby on Rails and ImageMagick.
If you do not install any of them, please follow the instructions below.

If you are using windows, I will recommend you to install Ubuntu on your machine through this link:
https://ubuntu.com/tutorials/ubuntu-on-windows

1. Install Ruby on Rails
- Please use the following commands to install Ruby on Rails on your localhost:
```
sudo apt update
sudo apt install -y git curl libssl-dev libreadline-dev zlib1g-dev autoconf bison build-essential libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc
rbenv install 3.0.2
rbenv global 3.0.2
gem install bundler
gem install rails -v 6.1.4.1
rbenv rehash
```

- To see if Ruby on Rails install correctly, you can use the following command to check their version:
```
ruby -v
bundler -v
rails -v
```

2. Install ImageMagick
- Please use the following commands to install ImageMagick on your localhost:
```
sudo apt install -y imagemagick
```

3. Install NodeJS and yarn
- Please use the following commands to install NodeJS and yarn on your localhost:
```
curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash -
sudo apt install -y nodejs
sudo apt install -y build-essential
```

- To see if NodeJS and npm install correctly, you can use the following command to check their version:
```
node -v
npm -v
```

- If NodeJS and npm install correctly, you can install yarn with the following command:
```
sudo apt remove -y cmdtest
sudo apt remove -y yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install -y yarn
```

- To see if yarn install correctly, you can use the following command to check it's version:
```
yarn --version
```

4. Switch to your rails project directory, and clone this application into your localhost
- You can use the following commands to clone the application into your C driver:
```
cd /mnt/c/[YOUR_RAILS_PROJECT_DIRECTORY]/
git clone https://github.com/Skogkatt-L/ASCII-Nobeta.git && cd ASCII-Nobeta
```
or using the following commands to clone into your preferred directory:
([YOUR_RAILS_PROJECT_DIRECTORY] = Your Rails Project Directory)
([YOUR_APPLICATION_DIRECTORY] = Your Application Directory)
```
cd /mnt/c/[YOUR_RAILS_PROJECT_DIRECTORY]/
git clone https://github.com/Skogkatt-L/ASCII-Nobeta.git [YOUR_APPLICATION_DIRECTORY]
cd [YOUR_APPLICATION_DIRECTORY]
```

5. Install gems (mini_magick, rainbow, etc) and yarn (Bootstrap, Jquery, popperjs, etc)
```
bundle install
yarn install
```

6. You can now start your rails server by the following command:
```
rails s
```

7. Open the application on your browser:
http://localhost:3000/

8. Press Ctrl-C to stop the server
