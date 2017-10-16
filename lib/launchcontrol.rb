#!/usr/bin/ruby

require 'rubygems'
require 'plist'
require 'pathname'

# LaunchControl is a utility application to manage startup programs on your macosx installation.
module LaunchControl

	# Holds basic information about a LaunchAgent.
	class LaunchAgent
		attr_accessor :name, :id, :program, :program_arguments, :run_at_load
		attr_accessor :limit_load_to_session_type, :start_interval, :standard_error_path, :standard_out_path
		attr_accessor :disabled, :keep_alive, :meta
		attr_accessor :file_path
		
		# Initializes a launch agent with the given path
		# @param file_path [String] The file path to this LaunchAgent
		def initialize file_path
			@file_path = file_path
			@meta = {}
		end

		# Currently empty method. This will be used to save any changes to a launch item
		# Eg. StartInterval or RunAtLoad.
		def save
		end
	end

	# Global utility to collect and operate with launch agents.
	class LaunchControl
		# @note I don't recommend changing these because you can't enable any launch agents which were
		# 		disabled before changing these. it's best to keep them as they are.
		TAG_DISABLED_START = "<!--LC:DISABLED"
		# @note I don't recommend changing these because you can't enable any launch agents which were
		# 		disabled before changing these. it's best to keep them as they are.
		TAG_DISABLED_END = "-->"

		attr_accessor :launch_agents

		# Disable a single launch agent or all launch agents
		# @param launch_agent [LaunchAgent]   The id of the launch_agent or '--all' to disable every found launch agent.
		# @return [boolean] A status whether or not the operation went successfully.
		def self.disable(launch_agent)
			source = open(launch_agent.file_path, "r") do |f| f.read end
			source = LaunchControl::TAG_DISABLED_START + "\n" + source + "\n" + LaunchControl::TAG_DISABLED_END
			success = true
			begin
				open(launch_agent.file_path, "w") do |f| f.write(source) end
			rescue Exception => e
				success = false
			end
			success
		end

		# Enable a single launch agent or all launch agents
		# @param launch_agent [LaunchAgent]   The id of the launch_agent or '--all' to enable every found launch agent.
		# @return [boolean] A status whether or not the operation went successfully.
		def self.enable(launch_agent)
			source = open(launch_agent.file_path, "r") do |f| f.read end
			source = source.sub(LaunchControl::TAG_DISABLED_START, "").sub(LaunchControl::TAG_DISABLED_END, "")
			success = true
			begin
				open(launch_agent.file_path, "w") do |f| f.write(source) end
			rescue Exception => e
				success = false
			end
		end

		# Returns a list of all launch agents found within the searching folders
		# @see launch_agent_folders for a list of all folders
		# @return [Array<LaunchItem>] A list of Launch Items
		def find_all
			@launch_agents = []
			launch_agent_folders.each do |folder|
				 @launch_agents << Dir["#{folder}/**.plist"]
			end
			@launch_agents.flatten!
			@launch_agents = @launch_agents.map do |li| parse_launch_agent li end
			@launch_agents = @launch_agents.select do |li| li != false end
		end

		# Parses a LaunchAgent.plist file
		# This method resolves symlinks and checks whether or not a LaunchAgent has already been disabled
		# by LaunchControl. It does skip launch agents which couldn't be parsed correctly (e.g. empty or otherwise invalid)
		# Since these launch agents cannot be started by macosx itself, it's best to delete them.
		# @param launch_agent [String] Path to a launch agent.
		# @return [LaunchItem] the parsed launch item
		# @see LaunchItem
		def parse_launch_agent launch_agent
			li = LaunchAgent.new(launch_agent)

			begin
				parser = Plist::parse_xml(launch_agent)
				source = open(resolve_symlinks(launch_agent), "r").read()
			rescue Exception => e
				# symlink detected. skip it
				return false
			end

			if parser.nil? 
				if source.split("\n")[0] == LaunchControl::TAG_DISABLED_START
					li.disabled = true
					parser = Plist::parse_xml(source.gsub(LaunchControl::TAG_DISABLED_START, "").gsub(LaunchControl::TAG_DISABLED_END, ""))
				else
					return false 
				end
			else
				li.disabled = false
			end

			
			li.id = Pathname.new(resolve_symlinks launch_agent).basename.to_s.sub(".plist", "")
			li.name = parser["Label"]
			li.program = parser["Program"]
			li.program_arguments = parser["ProgramArguments"]
			li.run_at_load = parser["RunAtLoad"]
			li.start_interval = parser["StartInterval"]
			li.keep_alive = parser["KeepAlive"]
			#li.disabled = parser["Disabled"]

			# Save other keys (mostly app specific)
			parser.each do |k, v|
				unless ["Label", "Program", "ProgramArguments", "RunAtLoad", "StartInterval", "KeepAlive", "Disabled"].include? k
					li.meta[k.to_sym] = v
				end
			end
			li
		end

		# Returns a list of all folders where LaunchAgents are stored.
		# You can only add more launch daemon folders to this file if you subclass it.
		# @return [Array<String>] The folders where launch agents are stored.
		def launch_agent_folders
			[
				"/Library/LaunchDaemons",
				"/Library/LaunchAgents",
				"/Users/#{ENV['USER']}/Library/LaunchAgents"
			]
		end

		# Resolve symlinks
		# @param item [String] The path you want to resolve
		# @return [String] the resolved path
		def resolve_symlinks item
			begin
				path = Pathname.new(item).realpath
			rescue Exception => e
				path = item
			end
			path
		end
	end
end