# function first is important 
# fill!(A,0)?
# foo(x::Real) try to be loose on real number than Float64
# include compatibility bounds in the package Project.toml
# why activate local folder?
# travis not working anymore
# vscode loads revise.jl automatically, to reflect the changes to the code
# vector allocates on cpu while similar(x) may alllocate the same location like on GPU 
# mean(x.^2) allocates
# Julia always uses sin(scalar), for vector uses sin.(scalar)
# cond && return x; if cond then return x
# cond || return x; if !cond then return x 
# .so system image