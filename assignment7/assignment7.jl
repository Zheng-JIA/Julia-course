# Motion control of a single joint
# τ = M*θddot + m*g*r*cos(θ) + b*θdot
using Pkg
pkg"activate ./assignment7"
pkg"instantiate"
pkg"precompile"
using DifferentialEquations, ModelingToolkit, Plots, ControlSystems, ReachabilityAnalysis

@variables t θ(t) θdot(t) θddot(t) τ(t)
@constants M = 0.5 
@constants m = 1
@constants r = 0.1
@constants b = 0.1
@constants g = 9.81
# Forward dynamics
D = Differential(t)
# PD control gains
@parameters kp 
@parameters kd
# how to include saturation in control ??
eqns = [τ ~ m*g*r*cos(θ)-kp*θ-kd*θdot, # PD control with gravity compensation
        D(θ) ~ θdot, 
        D(θdot) ~ (τ - m*g*r*cos(θ) - b*θdot)/M]
@named sys = ODESystem(eqns)

prob = ODEProblem(structural_simplify(sys), [θ => pi, θdot => 0.0], (0.0, 10.0), [kp => 3.0, kd => 2.0])

sol = solve(prob)
plot(sol, vars=[θ,θdot,τ])
 

# ReachabilityAnalysis
@taylorize function SingleJoint!(xdot, x, params, t)
    local M = 0.5 
    local m = 1
    local r = 0.1
    local b = 0.1
    local g = 9.81
    local kp = 3.0
    local kd = 2.0
    xdot[1] = x[2]
    xdot[2] = (m*g*r*cos(x[1]) - kp*x[1]-kd*x[2] - m*g*r*cos(x[1]) - b*x[2])/M
end

X0 = Hyperrectangle(low=[0.9*pi/2, -0.1*pi], high=[1.1*pi/2, 0.1*pi])
probs = @ivp(x' = SingleJoint!(x), x(0) ∈ X0, dim=2)

sol = ReachabilityAnalysis.solve(probs, tspan=(0.0, 20.0), alg=TMJets21a())

# The box shape is a bit hard to understand though, does it cover the actual state?
plot(sol, vars=(1, 2), xlab="θ", ylab="θdot", lw=0.5, color=:red)