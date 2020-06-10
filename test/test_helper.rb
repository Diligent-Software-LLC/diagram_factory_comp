$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require_relative "../lib/diagram_factory_comp"
require 'node_diagram'
require 'node_adapter'
require "minitest/autorun"
