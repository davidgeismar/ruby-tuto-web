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
  def print_at_bit
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
http://www.cse.cuhk.edu.hk/~taoyf/course/comp3506/lec/dyn-array.pdf

# performing amortize analysis on dynamic arrays
# generally we analyse algorithm with asymptotic analysis
# asymptotic analysis how time grows when the input of the algorithm grows
# for example a simple loop algorithm grows linearly as the input grows

# amortized analysis is another way to study time efficiency of an algorithm
# it is more appropriate in situations where an algorithm has operation that take very little time and happen often (not costly)
# and 1 operation that takes a lot of time but doesnt happen often

# it is the case with dynamic arrays as most of the time adding an element to the array is a small cheap operation
#  whereas occasionaly you can have a very costly operation (copying all the elements to a new resized array)

# doing this takes  O(n) time if you apply asymptotic analysis
# But appends take O(n) time only when we insert into a full array
#  So in most cases appending is still O(1)O(1) time, and sometimes it's O(n)O(n) time.

# "Amortize" is a fancy verb used in finance that refers to paying off the cost of something gradually.
# With dynamic arrays, every expensive append where we have to grow the array "buys" us many cheap appends in the future.
# Conceptually, we can spread the cost of the expensive append over all those cheap appends.

# The cost of doing mm appends is mm (since we're appending every item),
# plus the cost of any doubling when the dynamic array needs to grow. How much does the doubling cost?

# 1 + 2 + 4 + 8 + .... + m/2 + m
# So when we do m appends, the appends themselves cost m, and the doubling costs 2m
#
# Put together, we've got a cost of 3m, which is O(m). So on average, each individual append is O(1). m appends cost us O(m).





-----

# In such cases, it is often too crude to estimate the total time spend by these operations using the number
# of operations multiplied by the worst-case running time for one operation. This is because maybe only a
# small fraction of the operations take a long time.
# Amortized analysis tries to analyze the cost of th


-----

# If we use simple analysis, the worst case cost of an insertion is O(n).
# Therefore, worst case cost of n inserts is n * O(n) which is O(n2).
# This analysis gives an upper bound, but not a tight upper bound for n insertions as all insertions don’t take Θ(n) time.


# https://www.geeksforgeeks.org/analysis-algorithm-set-5-amortized-analysis-introduction/

# check why 1 + 2 + 4 +8 +.....+n/2 + n = log2(n - 1) +1 ???? = 2m
