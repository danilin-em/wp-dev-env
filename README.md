# wp-dev-env
Wordpress Development Environment

## Usage

```bash

# Go to projects directory
cd projects/directory
# Download wp-dev-env
wget https://github.com/danilin-em/wp-dev-env/archive/master.zip
# unzip this
unzip master.zip
# remove this
rm master.zip
# Go to wp-dev-env
cd wp-dev-env-master
# Build env image, download wordpress, download dev plugins
make
# Clone your project
make clone/git@github.com:danilin-em/my-super-theme.git

```

## Requirements

- docker
- docker-compose

- wget
- unzip
- sed

- composer
