#!env ruby

require 'broach'
require 'yaml'

require_relative 'src/client.rb'
require_relative 'src/github.rb'

begin
	client = Client.new
	client.handle_arguments()
rescue Exception => error
	puts "Something went wrong\n #{error.message}"
end