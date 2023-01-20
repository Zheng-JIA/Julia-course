# fun = fun1(), fun2(), ... a hack to avoid redefinition error
# anything outside the function will not be complicated
# f(x::Int) = 2 * x; #::Int will not help performance 
# runtime dispatch of type stability; be aware of that numbers always have types
# Body is the return value of the function. Union{a, b, c} type can be any of a,b,calculate
# Julia is column. Fetch memory is expansive. Depending on the memory size, which memory?
# Array pass as reference.  By convention, put ! in function definition to indicate the memory content can be changed.
# Those function whose sizes are fixed iwll be put to stack. Otherwise put to heap (very expensive), ch
# zeros(5) 5 is not a buildt-in type and will be put into heap.
# reduce allocation, espectially when using threads since they are competing for the access to the memory
# check the result after using tturbo 

#@edit @enter
# using StaticArrays
# a = @Svector zeros(3)
# isbits(a)

# A = @SMatrix randn(3,3)
# @edit inv(A)

# over 100 element SMatrix, compiler will fail to compile

# a = randn(3,1000) has the same memeory allocation as [@SMatrix for ]? why
# R = similar(a)
# particle filter Fredirk 1.3 secs, allocation reduction 26,000