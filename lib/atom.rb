#
# Copyright (c) 2006 Martin Traverso
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# 

require 'xmlmapping'
require 'time'

module Atom
	NAMESPACE = 'http://www.w3.org/2005/Atom' 

	class Text < String
		attr :mime_type

		def initialize(element)
			type = element.attribute('type', NAMESPACE)
			
			@mime_type = if type.nil?
				'text/plain'
			else
				case type.value
					when 'text': 'text/plain'
					when 'xhtml': 'text/xhtml'
					else type.value
				end
			end

			value = case @mime_type
				when 'text/plain': element.texts.join
				else element.children.to_s
			end

			super value
		end
	end

	class Person
		include XMLMapping

		namespace NAMESPACE

		has_one :name
		has_one :email
		has_one :uri

		def to_s
			if !email.nil?
				"#{name} (#{email})"
			else
				name
			end
		end
	end

	class Generator
		include XMLMapping

		namespace NAMESPACE

		has_attribute :uri
		has_attribute :version
		text :name

		def to_s
			name
		end
	end

	class Link
		include XMLMapping

		namespace NAMESPACE

		has_attribute :href
		has_attribute :rel, :default => 'alternate'
		has_attribute :type
		has_attribute :hreflang
		has_attribute :title
		has_attribute :length

		def to_s
			href
		end
	end

	class Category
		include XMLMapping

		namespace NAMESPACE

		has_attribute :term
		has_attribute :scheme
		has_attribute :label

		def to_s
			term
		end
	end

	class Content
		include XMLMapping

		namespace NAMESPACE

		has_attribute :type
		has_attribute :src
		text :value

		def to_s
			value || src
		end
	end

	class Source
		include XMLMapping

		namespace NAMESPACE

		has_one :id
		has_many :authors, :name => 'author', :type => Person
		has_many :categories, :name => 'category', :type => Category
		has_one :generator, :type => Generator
		has_one :icon
		has_many :links, :name => 'link', :type => Link
		has_one :logo
		has_one :rights, :type => Text
		has_one :subtitle, :type => Text
		has_one :title, :type => Text
		has_one :updated, :transform => lambda { |t| Time.iso8601(t) }
		has_many :contributors, :name => 'contributor', :type => Person 
	end

	class Entry
		include XMLMapping

		namespace NAMESPACE

		has_one :id
		has_one :title, :type => Text
		has_one :summary, :type => Text
		has_many :authors, :name => 'author', :type => Person 
		has_many :contributors, :name => 'contributor', :type => Person 
		has_one :published, :transform => lambda { |t| Time.iso8601(t) }
		has_one :updated, :transform => lambda { |t| Time.iso8601(t) }
		has_many :links, :name => 'link', :type => Link
		has_many :categories, :name => 'category', :type => Category
		has_one :content, :type => Content
		has_one :source, :type => Source
		has_one :rights, :type => Text

		has_many :extended_elements, :name => :any, :namespace => :any, :type => :raw
	end

	class Feed 
		include XMLMapping

		namespace NAMESPACE

		has_one :id
		has_one :title, :type => Text
		has_one :subtitle, :type => Text
		has_many :authors, :name => 'author', :type => Person
		has_many :contributors, :name => 'contributor', :type => Person
		has_many :entries, :name => 'entry', :type => Entry
		has_one :generator, :type => Generator
		has_many :links, :name => 'link', :type => Link
		has_one :updated, :transform => lambda { |t| Time.iso8601(t) }

		has_one :rights, :type => Text
		has_one :icon
		has_one :logo
		has_many :categories, :name => 'category', :type => Category
	end
end
		

if $0 == __FILE__ 
	require 'net/http'
	require 'uri'

	str = Net::HTTP::get(URI::parse('http://blog.ning.com/atom.xml'))
	feed = Atom::Feed.new(str)

	feed.entries.each { |entry|
		puts "'#{entry.title}' by #{entry.authors[0].name} on #{entry.published.strftime('%m/%d/%Y')}"
	}
end
