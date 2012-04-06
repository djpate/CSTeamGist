class Client

	def initialize()
		@config = YAML::load_file(Dir.pwd + '/config/config.yaml')
		@github = Github.new(@config['github']['username'],@config['github']['password']);
		Broach.settings = { 'account' => @config['campfire']['account'],
							'token' => @config['campfire']['token'],
							'use_ssl' => true 
					    }
	end

	def post_file(filename, share = nil)
		if File.exist?(filename)
			response = @github.post_gist(File.basename(filename),File.open(filename).read);
			puts 'the file '+File.basename(filename)+' has been uploaded to '+response['html_url']
			if (share != nil)
				Broach.speak(@config['campfire']['room'], 'I just uploded a gist for everyone @ ' + response['html_url'])
				puts('...and shared')
			end
		else
			raise "File '#{filename}' does not exists"
		end
	end

	def list
		gists = @github.get_gists
		gists.each do |gist|
			gist['files'].each do |file|
				puts file[0]+'('+gist['id']+')'
			end
			puts gist['html_url']+"\n\n"
		end
	end

	def get(id, restore_dir = nil)
		gist = @github.get_gist(id)
		gist['files'].each do |file|
			if(restore_dir == nil)
				puts file[0] + "\n" + file[1]['content']
			else
				if File.directory?(restore_dir)
					File.open(restore_dir+'/'+file[0], 'w') do |f|
						f.write(file[1]['content'])
						puts  restore_dir+'/'+file[0] +' has been restored'
					end
				else
					raise "#{restore_dir} is not a directory"
				end
			end
		end
	end

	def handle_arguments()

		if(ARGV.length == 0)
			rtfm()
		else

			case ARGV[0]
				when 'create'
					if ARGV.length == 2
						post_file(ARGV[1])
					end
				when 'share'
					if ARGV.length == 2
						post_file(ARGV[1], true)
					end
				when 'list'
					list()
				when 'display'
					if ARGV.length == 2
						get(ARGV[1])
					end
				when 'restore'
					if ARGV.length == 3
						get(ARGV[1], ARGV[2])
					end
			end

		end
	end

	def rtfm()
		puts 'Gist ruby implementation :'
		puts 'create <filename> - Creates a GIST'
		puts 'share <filename>  - Creates a GIST and share it on campfire'
		puts 'list - List all your gists'
		puts 'display <id> - Display content of a GIST'
		puts 'restore <id> <directory> - Restore a GIST to a given directory'
	end

end