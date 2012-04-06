require 'net/http'
require 'net/https'
require 'uri'
require 'json'

class Github

	@@base_url = 'https://api.github.com'

	def initialize(username, password)
		@username = username
		@password = password
	end

	def get_gists(user = nil)
		if( user == nil)
			ap = "/gists"
		else 
			ap = "/users/#{user}/gists"
		end

		return request(ap)
	end

	def get_gist(id)
		ap = "/gists/#{id}"

		return request(ap)
	end

	private
	def request(url)
		
		uri 			= URI.parse(@@base_url + url)
		
		http 			= Net::HTTP.new(uri.host, uri.port)
		http.use_ssl 	= true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE

		request 		= Net::HTTP::Get.new(uri.request_uri)
		request.basic_auth(@username,@password)

		return JSON.parse(http.request(request).body)
	end

end

g = Github.new('djpate','....');
gists = g.get_gists('djpate')

gists.each do |gist|
	g.get_gist(gist['id'])['files'].each  do |key, content|
		p content['content']
	end
end
