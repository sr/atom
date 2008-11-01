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
    blank_mappings = { :element => {}, :attribute => {}, :text => {}, :namespace => nil }

    mod.extend(ClassMethods)
    mod.instance_variable_set(:@raw_mappings, {})
    mod.instance_variable_set(:@mappings, blank_mappings)
  end


  def initialize(input)
    root = parse(input)

    mappings     = self.class.mappings
    raw_mappings = self.class.raw_mappings

    # initialize :many attributes
    raw_mappings.values.select { |mapping| mapping[:cardinality] == :many }.each do |mapping|
      instance_variable_set("@#{mapping[:attribute]}", [])
    end

    # initialize defaults
    raw_mappings.values.select { |mapping| mapping[:default] }.each do |mapping|
      instance_variable_set("@#{mapping[:attribute]}", mapping[:default])
    end

    root.each_element { |element| process(element, mappings[:element]) }

    root.attributes.each_attribute { |attribute| process(attribute, mappings[:attribute]) }

    mappings[:text].values.each do |mapping|
      name = mapping[:attribute]
      value = extract_value(root, mapping)
      instance_variable_set("@#{name}", value)
    end
  end


  private
    def process(element, mappings)
      mapping = find_mapping(mappings, element.namespace, element.name)

      if mapping
        value = extract_value(element, mapping)
        attribute = mapping[:attribute]
        previous  = instance_variable_get("@#{attribute}")
        case mapping[:cardinality]
        when :one
          instance_variable_set("@#{attribute}", value)
        when :many
          previous << value
        end
      end
    end

    def find_mapping(mappings, namespace, name)
      mappings.values_at([namespace, name], [namespace, :any], [:any, :any] ).compact.first
    end

    def extract_value(node, mapping)
      value =
        if mapping[:type]
          type = mapping[:type]
          type == :raw ? node : type.new(node)
        elsif node.node_type == :element
          node.texts.map(&:value).to_s
        elsif node.node_type == :attribute
          node.value
        else
          raise "Unexpected node: #{node.inspect}"
        end

      value = mapping[:transform].call(value) if mapping[:transform]
      value
    end

    def parse(input)
      if input.respond_to?(:to_str)
        REXML::Document.new(input).root
      elsif input.respond_to?(:node_type) && input.node_type == :document
        input.root
      elsif input.respond_to?(:node_type) && input.node_type == :element
        input
      else
        raise ArgumentError, "Invalid input: #{input}"
      end
    end

  module ClassMethods
    def raw_mappings
      @raw_mappings || superclass.raw_mappings
    end

    def mappings
      @mappings || superclass.mappings
    end

    def namespace(namespace)
      initialize_mapping

      mappings[:namespace] = namespace
    end

    def has_one(attribute, options = {})
      add(attribute, :element, options.update(:cardinality => :one))
    end

    def has_many(attribute, options = {})
      add(attribute, :element, options.update(:cardinality => :many))
    end

    def has_attribute(attribute, options = {})
      add(attribute, :attribute, options)
    end

    def text(attribute, options = {})
      add(attribute, :text, options.update(:namespace => :any))
    end

    def ensure(message, &block)
    end

    private
      def add(attribute, xml_type, mapping)
        attr_reader attribute

        initialize_mapping

        mapping[:namespace]   ||= mappings[:namespace]
        mapping[:cardinality] ||= :one
        mapping[:name]        ||= attribute.to_s
        mapping[:attribute]   = attribute

        qualified_name = [ mapping[:namespace], mapping[:name] ]
        mappings = @mappings[xml_type][qualified_name] = mapping

        raw_mappings[attribute] = mapping
      end

      def initialize_mapping
        @mappings     ||= deep_clone(superclass.mappings)
        @raw_mappings ||= deep_clone(superclass.raw_mappings)
      end

      def deep_clone(object)
        case object
        when Hash
          object.entries.inject({}) do |hash, entry|
            hash[entry.first] = deep_clone(entry.first)
            hash
          end
        when Array
          object.map(&:deep_clone)
        else
          object
        end
    end
  end
end
