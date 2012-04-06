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

	def post_gist(filename, content)
		
		info = {
			'public' => true,
			'files' => {
				filename => {
					'content' => content
				}
			}
		}

		json = info.to_json

		return request('/gists', json)

	end

	private
	def request(url, post = nil)
		
		uri 			= URI.parse(@@base_url + url)
		
		http 			= Net::HTTP.new(uri.host, uri.port)
		http.use_ssl 	= true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE

		if( post == nil)
			request 		= Net::HTTP::Get.new(uri.request_uri)
		else
			request 		= Net::HTTP::Post.new(uri.request_uri,initheader = {'Content-Type' =>'application/json'})
			request.body 	= post
		end
		
		request.basic_auth(@username,@password)

		return JSON.parse(http.request(request).body)
	end



end
