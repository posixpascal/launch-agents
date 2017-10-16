#!/usr/bin/ruby

require_relative './lib/launchcontrol.rb'
require 'terminal-table'
require 'thor'
require 'rainbow'
require 'rainbow/ext/string'


class LaunchControlCli < Thor
	include LaunchControl
	attr_accessor :launch_agents


	desc "enable ID", "Disable a launch item by identifier or pass --all to enable all"
	def enable(id)
		@launch_agents = LaunchControlCli.get_launch_agents()
		
		tbd_li = @launch_agents.select { |li|
			(li.id == id or id == "--all")
		}
		unless tbd_li.nil?
			tbd_li.each do |li| 
				if LaunchControl.enable(li) 
					puts "Successfully enabled: #{li.id}"
				else 
					puts "Could not enable: #{li.id}"
				end

			end
		end
	end

	desc "disable ID", "Disable a launch item by identifier or pass --all to disable all"
	def disable(id)
		@launch_agents = LaunchControlCli.get_launch_agents()
		
		tbd_li = @launch_agents.select { |li|
			(li.id == id or id == "--all")
		}
		unless tbd_li.nil?
			tbd_li.each do |li| 
				if LaunchControl.disable(li) 
					puts "Successfully disabled: #{li.id}"
				else 
					puts "Could not disable: #{li.id}"
				end
			end
		end
	end

	desc "list", "List all available launch items"
	method_option :format, :aliases => "-f", :desc => "Change the output format supported: table(*), json, text, list. (*) = default."
	def list(format = "table")
		if options[:format]
			format = options[:format]
		end
		@launch_agents = LaunchControlCli.get_launch_agents()

	    if format == "table"
	    	rows = []
	    	
			@launch_agents.each_with_index do |li, index|
				rows << [index + 1, li.id.color(:cyan), {:value => li.disabled ? "YES" : "NO", :alignment => :right}, {:value => li.run_at_load ? "YES" : "NO", :alignment => :right}]
			end
			
			table = Terminal::Table.new :title => "Launch Agents", :headings => ["ID", Rainbow("Name").bg(:cyan).color(:white), "Disabled", "Run At Load"], :rows => rows
			puts table
	    elsif format == "text"
	    	@launch_agents.each_with_index do |li, index|
	    		puts "#{li.name} - disabled: #{li.disabled ? 'YES' : 'NO'}"
	    	end
	    elsif format == "json"
	    	puts @launch_agents.to_json
	    elsif format == "list"
	    	@launch_agents.each_with_index do |li, index|
	    		out = [
	    			"(#{index + 1}) #{li.id}".color(:cyan),
	    			"-" * ("#{index}) #{li.id}".size + 1),
					"Disabled: \t#{li.disabled ? 'YES' : 'NO'}",
					"RunAtLoad: \t#{li.run_at_load ? 'YES' : 'NO'}",
					"KeepAlive: \t#{li.keep_alive ? 'YES' : 'NO'}",
					"StartInterval: \t#{li.start_interval ? li.start_interval : '-'}\n\n"
	    		].join("\n")
	    		puts out
	    	end
	    else
	    	puts "Unknown format."
	    end
	    
	end

	def self.get_launch_agents
		LaunchControl.new().find_all()
	end
end

LaunchControlCli.start(ARGV)