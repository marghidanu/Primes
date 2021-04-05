require "bit_array"

DICT = {
           10_u64 => 4,
          100_u64 => 25,
         1000_u64 => 168,
        10000_u64 => 1229,
       100000_u64 => 9592,
      1000000_u64 => 78498,
     10000000_u64 => 664579,
    100000000_u64 => 5761455,
   1000000000_u64 => 50847534,
  10000000000_u64 => 455052511,
}

struct PrimeSieve
  getter sieve_size = 0_u64
  getter bits : Array(Bool)

  def initialize(@sieve_size)
    @bits = Array(Bool).new(@sieve_size, true)
  end

  def run_sieve
    factor = 3
    while factor <= Math.sqrt(@sieve_size)
      num = factor

      while num < @sieve_size
        if @bits[num]
          factor = num
          break
        end
        num += 2
      end

      num2 = factor * factor
      while num2 < @sieve_size
        @bits[num2] = false
        num2 += factor * 2
      end

      factor += 2
    end
  end

  def print_results(show_results : Bool, duration : Float64, passes : Int32)
    printf("2, ") if show_results

    count = 1
    (3..@sieve_size).step(2).each do |v|
      if @bits[v]
        printf("%d", v) if show_results
        count += 1
      end
    end

    puts if show_results

    printf("Passes: %d Time: %f Avg: %f Limit: %d Count1: %d Count2: %d Valid: %s\n",
      passes,
      duration,
      (duration / passes),
      @sieve_size,
      count,
      count_primes(),
      validate_results(),
    )
  end

  def count_primes
    ((3..@sieve_size).step(2).select { |v| @bits[v] }).size + 1
  end

  def validate_results
    DICT[@sieve_size] == count_primes()
  end
end

passes = 0
start_time = Time.utc.to_unix

loop do
  sieve = PrimeSieve.new(1000000_u64)
  sieve.run_sieve
  passes += 1

  duration = (Time.utc.to_unix - start_time).to_f64
  if duration >= 5
    sieve.print_results(false, duration, passes)
    break
  end
end
