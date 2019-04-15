require 'ffi'
class StaticArray
  attr_accessor :pointer, :capacity, :next_index
  extend FFI::Library

  ffi_lib './create_array/create_array.so'
  attach_function :create_static_array, [:int], :pointer

  def initialize(capacity)
    @capacity = capacity
    @pointer = create_static_array(capacity)
    @next_index = 0
  end

  def push(val)
    @pointer[4*@next_index].write(:int, val)
    @next_index += 1
  end

  def [](index)
    raise IndexOutOfBoundException if index >= @capacity
    self.pointer[4*index].read(:int)
  end

  # def []=(index, value)
  #   @pointer[index].write(:int, value)
  # end
# prints every value in the array
  def print
    i = 0
    while (i < @capacity)
      puts @pointer[i*4].read(:int)
      i += 1
    end
  end
  def print
    i = 0
    while (i < @capacity)
      puts @pointer[i].read(:int)
      i += 1
    end
  end
end

class DynamicArray
  def initialize
    @size = 0
    @capacity = 1
    @current_index = 0
    @static_array = StaticArray.create_static_array(@capacity)
  end

  def add(element)
    @size += 1
    resize_array if @size > @capacity
    @static_array[@current_index] = element
    @current_index += 1
  end

  private

  def resize_array
    @capacity = @capacity*2
    new_arr = StaticArray.create_static_array(@capacity)
    @static_array.each_with_index do |val, index|
      new_arr[index].write(:int, val)
    end
    @static_array = new_arr
  end
end

 #
 # /\/{2}(\w+\.(com|org))\//
 #
 # begins with //
