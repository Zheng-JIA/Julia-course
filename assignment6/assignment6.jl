using Pkg
using Zygote
using BenchmarkTools
# v1 = :(1/sqrt(:sigma))
# ξr = :(v1^2 - :sigmaDot^2)
# L(:ξ::Vector) = :(:ξ - ξr)^2

function cost(x::Vector)
    return [sqrt(sum(x.^2)), sin(sum(x.^2)), cos(sum(x.^2)), tan(sum(x.^2))]
end

N = 10
println("The length of input is $N")
x0 = rand(N)
# verify reverse and forward give the same results
isapprox.(jacobian(cost, x0), # reverse diff
         jacobian(x0) do x  # forward diff, not sure if there is an elegent way of writing this
            Zygote.forwarddiff(x) do x
            cost(x)
         end
end)
println("=================================Reverse diff benchmarking=================================")
@benchmark jacobian(cost, x0) # reverse diff: median time is 42.1 us
println("=================================Forward diff benchmarking=================================")
@benchmark jacobian(x0) do x  # forward diff: median time is 42.6 us
                Zygote.forwarddiff(x) do x
                    cost(x)
                end
            end
#-------------------------------------------------------------------------------------------------------------
N = 100
println("The length of input is $N")
x0 = rand(N)
println("=================================Reverse diff benchmarking=================================")
@benchmark jacobian(cost, x0) # reverse diff: median time is 56.1 us
println("=================================Forward diff benchmarking=================================")
@benchmark jacobian(x0) do x  # forward diff: median time is 139.0 us
                Zygote.forwarddiff(x) do x
                    cost(x)
                end
            end

#-------------------------------------------------------------------------------------------------------------
N = 1000
println("The length of input is $N")
x0 = rand(N)
println("=================================Reverse diff benchmarking=================================")
@benchmark jacobian(cost, x0) # reverse diff: median time is 118.4 us
println("=================================Forward diff benchmarking=================================")
@benchmark jacobian(x0) do x  # forward diff: median time is 14.0 ms
                Zygote.forwarddiff(x) do x
                    cost(x)
                end
            end

#-------------------------------------------------------------------------------------------------------------
N = 10000
println("The length of input is $N")
x0 = rand(N)
println("=================================Reverse diff benchmarking=================================")
@benchmark jacobian(cost, x0) # reverse diff: median time is 950.1 us
println("=================================Forward diff benchmarking=================================")
@benchmark jacobian(x0) do x  # forward diff: median time is 1.833 s
                Zygote.forwarddiff(x) do x
                    cost(x)
                end
            end

# When the input size is the same order of the output size, the forward and reverse diff approxiamtely performs similarly
# The reverse diff starts being more efficient when the input size is 10x more then the output size 
# It seems that the memory usage also grows much more faster for forward diff if input size is >> output size