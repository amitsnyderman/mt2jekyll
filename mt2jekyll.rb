#!/usr/bin/ruby

require 'date'

def new_post
	{
		:state => {
			:head => true,
			:body => nil
		},
		:categories => [],
		:tags => [],
		:date => nil,
		:title => nil,
		:body => '',
		:excerpt => '',
	}
end

posts = []
post = new_post

ARGF.each do |line|
	if post[:state][:head]
		next if line.empty?

		line.strip!

		if line =~ /^-{5}$/
			post[:state][:head] = false
			next
		end

		case line
		when /^TITLE: (.*)$/
			post[:title] = $1.gsub(/"/, '\"')
			next
		when /^DATE: (.*)$/
			post[:date] = $1
			next
		when /^PRIMARY CATEGORY: (.*)$/
		when /^CATEGORY: (.*)$/
			post[:categories] << $1
			next
		when /^TAGS: (.*)$/
			post[:tags] = $1
			next
		else
			# puts "skipped => #{line}"
		end
	else
		if line.strip =~ /^-{8}$/
			posts << post
			post = new_post
			next
		end

		if line.strip =~ /^-{5}$/
			post[:state][:body] = nil
			next
		end

		unless post[:state][:body]
			case line.strip
			when /^(\w+):$/
				post[:state][:body] = $1.downcase.to_sym
			end
			next
		end

		piece = post[:state][:body]
		if post[piece]
			post[piece] << line
		end
	end
end

posts.each do |p|
	date = DateTime.parse(p[:date])
	slug = p[:title].gsub(/[^\w\d\s]/, '').gsub(/[\s_]+/, '-').downcase
	filename = "_posts/#{date.strftime("%Y-%m-%d")}-#{slug}.markdown"

	puts "Writing to => #{filename}"
	File.open(filename, 'w') do |f|
		f.puts "---"
		f.puts "layout: post"
		f.puts "title: \"#{p[:title]}\""
		f.puts "date: #{date.to_s}"
		f.puts "categories:"
		p[:categories].each do |c|
			f.puts "- #{c}"
		end
		f.puts "tags:"
		p[:tags].each do |trow|
			trow.split(/[^\w\d]/).each do |t|
				f.puts "- #{t}"
			end
		end
		f.puts "---"
		f.puts p[:body]
	end
end