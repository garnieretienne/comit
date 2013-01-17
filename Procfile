web: bundle exec thin start -s1 --socket tmp/sockets/thin.sock -e production
worker: bundle exec sidekiq -P tmp/pids/sidekiq -L log/sidekiq.log -c 1