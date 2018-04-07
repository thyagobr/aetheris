require 'rubygems'
require 'gosu'
require 'pry'
require 'byebug'
require 'socket'
require './camera'
require './utils'
require './collision_box'
require './player'
require './screen'

#t1 = Thread.new do
  Screen.new.show
#end

#t2 = Thread.new do
#  server = TCPServer.open(2000)
#  loop do
#    client = server.accept
#    while line = client.gets
#      puts ".:! #{line}"
#      client.puts ".:! Unknown command"
#    end
#    client.puts ".:! Tchau"
#    client.close
#  end
#  server.close
#end
#
#t1.join
#t2.join
