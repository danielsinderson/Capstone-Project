using AlgebraicDynamics
using AlgebraicDynamics.DWDDynam
using Catlab.WiringDiagrams, Catlab.Programs

using LabelledArrays
using OrdinaryDiffEq, Plots, Plots.PlotMeasures

# Define the primitive systems
signal(u, x, p, t) = [4 * (10 < t < 10.5) - 4 * (10.5 < t < 11) + 4 * (20 < t < 20.5) - 4 * (20.5 < t < 21.0) + (30 < t < 33) - (50 < t < 53)]
activator1(u, x, p, t) = [p.β1 * (x[1] > p.κ1) - p.α1 * u[1]]
activator2(u, x, p, t) = [p.β2 * (x[1] > p.κ2) - p.α2 * u[1]]
activator_3_AND(u, x, p, t) = [p.β3 * (x[1] > p.κ3 && x[2] > p.κ4) - p.α3 * u[1]]

# ContinuousMachine{T}(ninputs, nstates, noutputs, f, r)
s = ContinuousMachine{Float64}(0, 1, 1, signal, (u, p, t) -> u)
X = ContinuousMachine{Float64}(1, 1, 1, activator1, (u, p, t) -> u)
Y = ContinuousMachine{Float64}(1, 1, 1, activator2, (u, p, t) -> u)
Z = ContinuousMachine{Float64}(2, 1, 1, activator_3_AND, (u, p, t) -> u)


# WiringDiagram([external inports], [external outports])
# Box(name, [inports], [outports])
# add_box!(wiring_diagram, box)
C1FFL = WiringDiagram([], [:signal_level, :Z_level])
signal_generator = add_box!(C1FFL, Box(:S, [], [:signal_level]))
geneX = add_box!(C1FFL, Box(:X, [:X_signal], [:X_level]))
geneY = add_box!(C1FFL, Box(:Y, [:X_level], [:Y_level]))
geneZ = add_box!(C1FFL, Box(:Z, [:X_level, :Y_level], [:Z_level]))


#add_wires(wiring_diagram, [
#    (box, output number) => (box, input_number),
#    (box, output number) => (box, input_number),
#    etc.
#])
add_wires!(C1FFL, [
    (signal_generator, 1) => (geneX, 1),
    (signal_generator, 1) => (output_id(C1FFL), 1),
    (geneX, 1) => (geneY, 1),
    (geneX, 1) => (geneZ, 1),
    (geneY, 1) => (geneZ, 2),
    (geneZ, 1) => (output_id(C1FFL), 2),
])


# final system = oapply(d::WiringDiagram, ms::Vector{M}) where {M<:AbstractMachine}
system = oapply(C1FFL, [s, X, Y, Z])


# Solve and plot
# x0 = LVector(X_signal=0)
u0 = [0, 0.25, 0, 0]
params = LVector(
    β1=1, κ1=0.5, α1=0.5,
    β2=1, κ2=0.5, α2=0.5,
    β3=1, κ3=0.5, κ4=0.5, α3=0.5
)
tspan = (0.0, 100.0)

# problem = ODEProblem(final system, u0, tspan, params)
# solution = solve(problem, Tsit5())
problem = ODEProblem(system, u0, tspan, params)
solution = solve(problem, Tsit5())

#plot(sol, rabbitfox_system, params,
#    lw=2, title="Lotka-Volterra Predator-Prey Model",
#    xlabel="time", ylabel="population size"
#)

plot(solution, system, params,
    lw=2, title="Coherent Feed Forward Loop Type 1",
    xlabel="time", ylabel="Presence of Transcription Factor Z"
)



