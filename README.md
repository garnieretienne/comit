# Introduction

Comit is an bloging platform backed by Git. Write, commit and push your publications online. Comit use Markdown markup language to convert your papers into blog posts.

# Installation

1. Clone the repository
   `git clone git://github.com/garnieretienne/comit.git`
2. Create a Github application and put credentials into an `.env` file
   ```
GITHUB_KEY=XXXXXXXXXXXX
GITHUB_SECRET=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
   ```
4. Install system dependencies (Redis)
   `sudo apt-get install redis` on debian / ubuntu
3. Install gem dependencies
   `bundle install`
4. Run database migration
   `bundle exec rake db:migrate`
4. Start the application
   `bundle exec foreman start`

## Create an user manually (no open registration during beta)

`bundle exec rails console`
```
irb> me = User.new name: 'Your name'
irb> me.provider = :github
irb> me.uid = 'xxxxxx' # find your github uid: http://caius.github.com/github_id/
irb> me.save
```
You can now login using this github user.

# Testing

## Test initialization:

```bash
mkdir tmp
git clone git://github.com/garnieretienne/comit-test.git tmp/comit-test
cp -rf tmp/comit-test tmp/test
cp -rf tmp/comit-test tmp/erased
cp -rf tmp/comit-test tmp/not_ready
git clone tmp/test repositories/test
git clone tmp/erased repositories/erased
rm -rf tmp/erased
```

### Run test

`bundle exec rake test`

## Test clean:

```bash
rm -rf repositories/*_not_ready
rm -rf repositories/*_comit-test
rm -rf repositories/erased
rm -rf repositories/test
rm -rf tmp/comit-test
rm -rf tmp/test
rm -rf tmp/erased
```

# Licence