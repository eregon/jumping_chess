def __dir__(caller1 = nil)
  current_file = (caller1 || caller(1, 1))[0].split(':', 2)[0]
  File.dirname(current_file)
end

def require(feature)
  path = feature
  path << ".rb" unless feature.end_with?("bin/jumping_chess")
  eval File.read(path), nil, path
end

def require_relative(feature)
  require File.expand_path(feature, __dir__(caller(1, 1)))
end

class Array
  def sum
    sum = 0
    each { |e| sum += yield(e) }
    sum
  end
end

ENV = {}
