web: bundle exec rails server thin -p $PORT -e production
worker: bundle exec sidekiq -P tmp/pids/sidekiq -L log/sidekiq.log -c 1