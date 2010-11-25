unless RUBY_VERSION >= '1.9.2'
  puts "Re-run under ruby 1.9.2. Exiting."
  exit
end

require_relative 'lib/shared'

pidfile = 'tmp/pids/server.pid'

desc "Starts the server"
task :start do
  #Process management - only needed in production
  unless ENV['ENV'] == 'development'
    Process.daemon(true)

    File.open(pidfile, 'w') { |f| f.write("#{Process.pid}") }
    at_exit { File.delete(pidfile) if File.exist?(pidfile) }
  end

  #For each app, run it in an instance of Rack::Server
  threads = []

  Sites.all.each do |site|
    rb = Rack::Builder.app do
      run site[:class]
    end
  
    rs = Rack::Server.new(:Port => site[:port], :server => 'mongrel')
    rs.instance_variable_set(:@app, rb)
    threads << Thread.new { rs.start }
  
    puts "#{site[:name]} running on #{site[:port]}"# if $DEBUG
  end

  #Make sure we wait for all servers to die before exiting
  threads.each{ |t| t.join }
end

task :stop do
  system("kill -9 `cat #{pidfile}`") if File.exists?(pidfile)
end

task :console do
  system("irb -r ./lib/preload.rb")
end

desc "Generate nginx configuration"
task :generate_nginx_config do
  f = File.open("/home/bloople/www/sinatra_apps/shared/lib/sinatra_apps.conf", "w")
  
  f << "# DO NOT EDIT this file; it was generated by #{__FILE__} at #{DateTime.now.strftime("%d/%m/%Y %I:%M%p")}\n\n"

  Sites.all.each do |site|
    name = site[:name].gsub('_', '')

    f << <<-EOF
# Configuration for #{site[:name]}
server {
  listen 80;
  server_name www.#{name}.bloople.net;
  rewrite ^/(.*) http://#{name}.bloople.net/$1 permanent;
}

server {
  listen 80;
  server_name #{name}.bloople.net;

  location / {
    root /home/bloople/www/sinatra_apps/current/#{site[:name]}/public/;
    index /;
    if (!-f $request_filename) {
      proxy_pass http://127.0.0.1:#{site[:port]};
    }
    include /etc/nginx/proxy.conf;
  }
}

EOF
  end

  f.close
end

=begin
desc "Clear caches"
task :clear_caches do
  Dir.glob("./*/public/cache/*").each { |dir| FileUtils.rm(dir) }
end
=end