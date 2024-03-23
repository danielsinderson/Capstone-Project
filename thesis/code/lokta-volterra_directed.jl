# CODE TAKEN FROM THE AlgebraicDynamics Docs

using AlgebraicDynamics
using AlgebraicDynamics.DWDDynam
using Catlab.WiringDiagrams, Catlab.Programs

using LabelledArrays
using OrdinaryDiffEq, Plots, Plots.PlotMeasures

# Define the primitive systems
dotr(u, x, p, t) = [p.α * u[1] - p.β * u[1] * x[1]]
dotf(u, x, p, t) = [p.γ * u[1] * x[1] - p.δ * u[1]]

rabbit = ContinuousMachine{Float64}(1, 1, 1, dotr, (u, p, t) -> u)
fox = ContinuousMachine{Float64}(1, 1, 1, dotf, (u, p, t) -> u)

# Define the composition pattern
rabbitfox_pattern = WiringDiagram([], [:rabbits, :foxes])
rabbit_box = add_box!(rabbitfox_pattern, Box(:rabbit, [:pop], [:pop]))
fox_box = add_box!(rabbitfox_pattern, Box(:fox, [:pop], [:pop]))

add_wires!(rabbitfox_pattern, Pair[
    (rabbit_box, 1)=>(fox_box, 1),
    (fox_box, 1)=>(rabbit_box, 1),
    (rabbit_box, 1)=>(output_id(rabbitfox_pattern), 1),
    (fox_box, 1)=>(output_id(rabbitfox_pattern), 2)
])

# Compose
rabbitfox_system = oapply(rabbitfox_pattern, [rabbit, fox])

# Solve and plot
u0 = [10.0, 100.0]
params = LVector(α=0.3, β=0.015, γ=0.015, δ=0.7)
tspan = (0.0, 100.0)

prob = ODEProblem(rabbitfox_system, u0, tspan, params)
sol = solve(prob, Tsit5())

plot(sol, rabbitfox_system, params,
    lw=2, title="Lotka-Volterra Predator-Prey Model",
    xlabel="time", ylabel="population size"
)