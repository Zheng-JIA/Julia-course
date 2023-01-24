using Distributed
println("number of workers=", length(workers()))
addprocs(6)
println("workers ids are ", workers())
@everywhere using Distributed 
@everywhere using Pkg
@everywhere pkg"activate ./assignment5" # Even if I cd to the dir "JULIA_COURSE/assignment5/" before start Julia, pkg"activate ." still activate project at "JULIA_COURSE"
@everywhere pkg"instantiate" # I don't have a Project.toml or Manifest.toml. This line of code creates these two files.
@everywhere pkg"precompile" # nothing happens...
@everywhere include("./assignment5.jl")


function sim(particle_count, time_steps)
    propagated_particles = 0 # To count the number of particle propagations
    retval = pmap(Iterators.product(particle_count, time_steps)) do (N, T) # This syntax creates a anonymous function passing (N, T) to the body
            propagated_particles
            montecarlo_runs = maximum(particle_count)*maximum(time_steps) ÷ T ÷ N # Calculate how many Monte-Carlo runs to perform for the current T,N configuration
            RMS = 0
            for mc_iter = 1:montecarlo_runs
                w = log.(1/N.*ones(N,T)) # Initialize weights (weights stored in logarithmic form)
                we = exp.(w)
                xp = zeros(Float64,N,T) # Define particle matrix    # remove global, and pass xp to function
                xp[:,1] = 2*σw*randn(N,1) # Initialize particles at time t=1 using 2σ as initial std
                x = zeros(Float64,1,T)
                y = zeros(Float64,1,T)
                y[1] = σv*randn()
                x[1] = σw*randn()
                for t = 1:T-1 # Simulate one realization of the model
                    x[t+1] = f(x[t],t) + σw*randn()
                    y[t+1] = 0.05x[t+1]^2  + σv*randn()
                end # t
                xh = pf( y, N, g, f, σw0 , xp, w, we) # Run the particle filter
                RMS += rms(x-xh) # Store the error
            end # MC
            propagated_particles += montecarlo_runs*N*T # Add the number of performed particle propagations
            RMS/montecarlo_runs # Store the mean of the error for this T,N configuration
    end # 
    println("Propagated $propagated_particles particles")
    return retval
end # begin @time

@everywhere particle_count = [5, 30, 100, 300, 1000, 10_000]
@everywhere time_steps = [20, 200, 2000]
@everywhere RMSE = zeros(length(particle_count),length(time_steps))
@time RMSE = sim(particle_count, time_steps)

using Plots
function plotting(RMSE, particle_count, time_steps)
    legend_strings = ["$(time_steps[i]) time steps" for i = 1:length(time_steps)]
    legend_strings = reshape(legend_strings,1,:)
    scatter(particle_count,RMSE, title="RMS errors vs Number of particles", xscale=:log10, lab=legend_strings)
end
plotting(RMSE, particle_count, time_steps)