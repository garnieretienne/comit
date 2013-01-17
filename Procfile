web: bundle exec rails server thin -p 3000 -e production
worker: bundle exec sidekiq -P tmp/pids/sidekiq -L log/sidekiq.log -c 1