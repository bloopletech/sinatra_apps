desc "Starts the server"
task :start do
  system("ruby run.rb")
end

desc "Generate nginx configuration"
task :generate_nginx_config do
  require 'lib/shared'

  f = File.open("sinatra_apps.conf", "w")
  
  f << "# DO NOT EDIT this file; it was generated by #{__FILE__} at #{DateTime.now.strftime("%d/%m/%Y %I:%M%p")}\n\n"

  Sites.all.each do |site|
    f << <<-EOF
# Configuration for #{site[:name]}
server {
  listen 80;
  server_name www.#{site[:name]}.bloople.net;
  rewrite ^/(.*) http://#{site[:name]}.bloople.net/$1 permanent;
}

server {
  listen 80;
  server_name #{site[:name]}.bloople.net;

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