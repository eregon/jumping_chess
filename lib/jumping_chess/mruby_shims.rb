class Array
  def sum
    sum = 0
    each { |e| sum += yield(e) }
    sum
  end
end

ENV = {}
