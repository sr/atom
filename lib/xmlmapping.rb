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

# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

require 'rexml/document'

module XMLMapping
	def self.included(mod)
		mod.extend(ClassMethods)
		mod.instance_variable_set("@attributes", {})
		mod.instance_variable_set("@elements", {})
		mod.instance_variable_set("@text_attribute", nil)
	end

	def initialize(input)
		if input.respond_to? :to_str
			root = REXML::Document.new(input).root
		elsif input.respond_to?(:node_type) && input.node_type == :document
			root = input.root
		elsif input.respond_to?(:node_type) && input.node_type == :element
			root = input
		else 
			raise "Invalid input: #{input}"
		end

		namespace = self.class.default_namespace
		attributes = self.class.attributes
		elements = self.class.elements
		text_attribute = self.class.text_attribute

		if !text_attribute.nil?
			name = text_attribute[0]
			options = text_attribute[1]
			value = root.text

			if options.has_key? :transform
				value = options[:transform].call(value)
			end

			instance_variable_set("@#{name}", value)
		else
			# initialize :many attributes
			elements.select { |k, v|
				v[:cardinality] == :many
			}.each { |k, v|
				instance_variable_set("@#{v[:attribute]}", [])
			}

			root.each_element { |e| 
				if e.namespace == namespace && elements.has_key?(e.name.to_sym)
					options = elements[e.name.to_sym]

					if options.has_key? :type
							value = options[:type].new(e)	
					else
							value = e.text
					end

					if options.has_key? :transform
						value = options[:transform].call(value)
					end

					attribute = options[:attribute]

					existing = instance_variable_get("@#{attribute}")
					case options[:cardinality]
						when :one 
							raise "Found more than one #{e.name}" if !existing.nil?
							instance_variable_set("@#{attribute}", value)
						when :many 
							existing << value
					end		
				end
			}
		end

		root.attributes.each_attribute { |a|
			if a.namespace == namespace && attributes.has_key?(a.name.to_sym)
				options = attributes[a.name.to_sym]

				value = a.value
				if options.has_key? :transform
					value = options[:transform].call(value)
				end

				instance_variable_set("@#{a.name}", value)
			end
		}
	end

	module ClassMethods
		attr :attributes
		attr :elements
		attr :text_attribute
		attr :default_namespace

		def namespace(namespace)
			@default_namespace = namespace
		end

		def has_one(attribute, options = {})
			attr attribute
			options[:cardinality] = :one
			options[:attribute] = attribute
			
			name = attribute
			if options.has_key? :name
				name = options[:name].to_sym
			end

			@elements[name] = options
		end

		def has_many(attribute, options = {})
			attr attribute
			options[:cardinality] = :many
			options[:attribute] = attribute

			name = attribute
			if options.has_key? :name
				name = options[:name].to_sym
			end

			@elements[name] = options
		end

		def has_attribute(attribute, options = {})
			attr attribute
			@attributes[attribute] = options
		end	

		def text(attribute, options = {})
			attr attribute
			@text_attribute = [attribute, options]
		end
	end
end
