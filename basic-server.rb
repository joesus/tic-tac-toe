require 'socket'
require_relative 'tic_tac_toe'
require_relative 'router'
require_relative 'game_controller'
require 'addressable/uri'
require 'pry-nav'

webserver = TCPServer.new 2000
current_dir = Dir.new(".")

counter = 0
while session = webserver.accept
  router = Router.new

  session.print "HTTP/1.1 200/OK\r\nContent-type:text/html\n\n"
  request = session.gets

  puts "Request_#{counter}: #{request}"

  if !request.nil?
    method = request.split.first.downcase
    sanitized_request = request.gsub(/GET /, '').gsub(/\ HTTP.*/, '').chomp
    uri = Addressable::URI.parse(sanitized_request)
    params = uri.query_values #JSON.parse(uri.query_values["json"]) rescue nil
    path = uri.path
    session.print "HTTP/1.1 200/OK\r\nContent-type:text/html\n\n"
    session.print "#{router.route(method, path, params)}"
    puts "Method_#{counter}: #{method}"
    puts "URI_#{counter}: #{uri}"
    puts "Path_#{counter}: #{path}"
  end

  counter += 1
#   if path == ""
#     path = "."
#   end
#
#   # File handling
#   if !File.exists?(path)
#     session.print "HTTP/1.1 404/Object Not Found\r\n"
#     session.close
#     next
#   end
#
#   if File.directory?(path)
#     session.print "HTTP/1.1 200/OK\r\nContent-type:text/html\n\n"
#     if path == ""
#       current_dir = Dir.new(".")
#     else
#       current_dir = Dir.new("./#{path}")
#     end
#     header = path
#     puts "header: #{header}"
#     session.print "
#   <h1>#{header}</h1>
#   "
#     current_dir.entries.each do |f|
#       if File.directory? f
#         session.print("
# <a href='#{f}/'>#{f}</a>
# ")
#       else
#         session.print("
# <a href='#{f}'>#{f}</a>
# ")
#       end
#     end
#   else
#     session.print File.open(path, "r").read
#   end

  session.close
end