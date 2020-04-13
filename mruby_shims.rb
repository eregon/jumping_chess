# This file is only loaded by mruby

module Kernel
  def require(feature)
  end

  def require_relative(feature)
  end
end

class Array
  def sum
    sum = 0
    each { |e| sum += yield(e) }
    sum
  end
end

# ARGV is defined by bin/mruby, but not when compiled to a wasm module
ARGV = [] unless Object.const_defined?(:ARGV)

ENV = {} unless Object.const_defined?(:ENV)
