using AlgebraicDynamics
using AlgebraicDynamics.DWDDynam
using Catlab

using LabelledArrays
using OrdinaryDiffEq, Plots, Plots.PlotMeasures

# Define the primitive systems
signal(u, x, p, t) = [0.4 * (1 < t < 4) - 0.4 * (7 < t < 8) + 0.4 * (8 < t < 9.1) - 0.4 * (12 < t < 15)]
flhDC(u, x, p, t) = [p.β1 * (x[1] > p.κ1) - p.α1 * u[1]]
fliA(u, x, p, t) = [p.β2 * (x[1] > p.κ2) - p.α2 * u[1]]
fliL(u, x, p, t) = [p.β3 * (x[1] > p.κ3 || x[2] > p.κ4) - p.α3 * u[1]]
fliE(u, x, p, t) = [p.β4 * (x[1] > p.κ5 || x[2] > p.κ6) - p.α4 * u[1]]
fliF(u, x, p, t) = [p.β5 * (x[1] > p.κ7 || x[2] > p.κ8) - p.α5 * u[1]]
flgA(u, x, p, t) = [p.β6 * (x[1] > p.κ9 || x[2] > p.κ10) - p.α6 * u[1]]
flgB(u, x, p, t) = [p.β7 * (x[1] > p.κ11 || x[2] > p.κ12) - p.α7 * u[1]]
flhB(u, x, p, t) = [p.β8 * (x[1] > p.κ13 || x[2] > p.κ14) - p.α8 * u[1]]
fliD(u, x, p, t) = [p.β9 * (x[1] > p.κ15 || x[2] > p.κ16) - p.α9 * u[1]]
flgK(u, x, p, t) = [p.β10 * (x[1] > p.κ17 || x[2] > p.κ18) - p.α10 * u[1]]
fliC(u, x, p, t) = [p.β11 * (x[1] > p.κ19 || x[2] > p.κ20) - p.α11 * u[1]]
meche(u, x, p, t) = [p.β12 * (x[1] > p.κ21 || x[2] > p.κ22) - p.α12 * u[1]]
mocha(u, x, p, t) = [p.β13 * (x[1] > p.κ23 || x[2] > p.κ24) - p.α13 * u[1]]
flgM(u, x, p, t) = [p.β14 * (x[1] > p.κ25 || x[2] > p.κ26) - p.α14 * u[1]]

# ContinuousMachine{T}(ninputs, nstates, noutputs, f, r)
s = ContinuousMachine{Float64}(0, 1, 1, signal, (u, p, t) -> u)
X = ContinuousMachine{Float64}(1, 1, 1, flhDC, (u, p, t) -> u)
Y = ContinuousMachine{Float64}(1, 1, 1, fliA, (u, p, t) -> u)
Z1 = ContinuousMachine{Float64}(2, 1, 1, fliL, (u, p, t) -> u)
Z2 = ContinuousMachine{Float64}(2, 1, 1, fliE, (u, p, t) -> u)
Z3 = ContinuousMachine{Float64}(2, 1, 1, fliF, (u, p, t) -> u)
Z4 = ContinuousMachine{Float64}(2, 1, 1, flgA, (u, p, t) -> u)
Z5 = ContinuousMachine{Float64}(2, 1, 1, flgB, (u, p, t) -> u)
Z6 = ContinuousMachine{Float64}(2, 1, 1, flhB, (u, p, t) -> u)
Z7 = ContinuousMachine{Float64}(2, 1, 1, fliD, (u, p, t) -> u)
Z8 = ContinuousMachine{Float64}(2, 1, 1, flgK, (u, p, t) -> u)
Z9 = ContinuousMachine{Float64}(2, 1, 1, fliC, (u, p, t) -> u)
Z10 = ContinuousMachine{Float64}(2, 1, 1, meche, (u, p, t) -> u)
Z11 = ContinuousMachine{Float64}(2, 1, 1, mocha, (u, p, t) -> u)
Z12 = ContinuousMachine{Float64}(2, 1, 1, flgM, (u, p, t) -> u)


# WiringDiagram([external inports], [external outports])
# Box(name, [inports], [outports])
# add_box!(wiring_diagram, box)
motor_diagram = WiringDiagram([], [
    :Z1_level,
    :Z2_level,
    :Z3_level,
    :Z4_level,
    :Z5_level,
    :Z6_level,
    :Z7_level,
    :Z8_level,
    :Z9_level,
    :Z10_level,
    :Z11_level,
    :Z12_level,
    :signal,
    #    :X_level,
    #    :Y_level
])
signal_generator = add_box!(motor_diagram, Box(:S, [], [:signal_level]))
geneX = add_box!(motor_diagram, Box(:X, [:X_signal], [:X_level]))
geneY = add_box!(motor_diagram, Box(:Y, [:X_level], [:Y_level]))
geneZ1 = add_box!(motor_diagram, Box(:Z1, [:X_level, :Y_level], [:Z1_level]))
geneZ2 = add_box!(motor_diagram, Box(:Z2, [:X_level, :Y_level], [:Z2_level]))
geneZ3 = add_box!(motor_diagram, Box(:Z3, [:X_level, :Y_level], [:Z3_level]))
geneZ4 = add_box!(motor_diagram, Box(:Z4, [:X_level, :Y_level], [:Z4_level]))
geneZ5 = add_box!(motor_diagram, Box(:Z5, [:X_level, :Y_level], [:Z5_level]))
geneZ6 = add_box!(motor_diagram, Box(:Z6, [:X_level, :Y_level], [:Z6_level]))
geneZ7 = add_box!(motor_diagram, Box(:Z7, [:X_level, :Y_level], [:Z7_level]))
geneZ8 = add_box!(motor_diagram, Box(:Z8, [:X_level, :Y_level], [:Z8_level]))
geneZ9 = add_box!(motor_diagram, Box(:Z9, [:X_level, :Y_level], [:Z9_level]))
geneZ10 = add_box!(motor_diagram, Box(:Z10, [:X_level, :Y_level], [:Z10_level]))
geneZ11 = add_box!(motor_diagram, Box(:Z11, [:X_level, :Y_level], [:Z11_level]))
geneZ12 = add_box!(motor_diagram, Box(:Z12, [:X_level, :Y_level], [:Z12_level]))


#add_wires(wiring_diagram, [
#    (box, output number) => (box, input_number),
#    (box, output number) => (box, input_number),
#    etc.
#])
add_wires!(motor_diagram, [
    (signal_generator, 1) => (geneX, 1),
    (geneX, 1) => (geneY, 1),
    (geneX, 1) => (geneZ1, 1),
    (geneX, 1) => (geneZ2, 1),
    (geneX, 1) => (geneZ3, 1),
    (geneX, 1) => (geneZ4, 1),
    (geneX, 1) => (geneZ5, 1),
    (geneX, 1) => (geneZ6, 1),
    (geneX, 1) => (geneZ7, 1),
    (geneX, 1) => (geneZ8, 1),
    (geneX, 1) => (geneZ9, 1),
    (geneX, 1) => (geneZ10, 1),
    (geneX, 1) => (geneZ11, 1),
    (geneX, 1) => (geneZ12, 1),
    (geneY, 1) => (geneZ1, 2),
    (geneY, 1) => (geneZ2, 2),
    (geneY, 1) => (geneZ3, 2),
    (geneY, 1) => (geneZ4, 2),
    (geneY, 1) => (geneZ5, 2),
    (geneY, 1) => (geneZ6, 2),
    (geneY, 1) => (geneZ7, 2),
    (geneY, 1) => (geneZ8, 2),
    (geneY, 1) => (geneZ9, 2),
    (geneY, 1) => (geneZ10, 2),
    (geneY, 1) => (geneZ11, 2),
    (geneY, 1) => (geneZ12, 2),
    (signal_generator, 1) => (output_id(motor_diagram), 13),
    #(geneX, 1) => (output_id(motor_diagram), 14),
    #(geneY, 1) => (output_id(motor_diagram), 15),
    (geneZ1, 1) => (output_id(motor_diagram), 1),
    (geneZ2, 1) => (output_id(motor_diagram), 2),
    (geneZ3, 1) => (output_id(motor_diagram), 3),
    (geneZ4, 1) => (output_id(motor_diagram), 4),
    (geneZ5, 1) => (output_id(motor_diagram), 5),
    (geneZ6, 1) => (output_id(motor_diagram), 6),
    (geneZ7, 1) => (output_id(motor_diagram), 7),
    (geneZ8, 1) => (output_id(motor_diagram), 8),
    (geneZ9, 1) => (output_id(motor_diagram), 9),
    (geneZ10, 1) => (output_id(motor_diagram), 10),
    (geneZ11, 1) => (output_id(motor_diagram), 11),
    (geneZ12, 1) => (output_id(motor_diagram), 12)
])


to_graphviz(motor_diagram)


# final system = oapply(d::WiringDiagram, ms::Vector{M}) where {M<:AbstractMachine}
system = oapply(motor_diagram, [s, X, Y, Z1, Z2, Z3, Z4, Z5, Z6, Z7, Z8, Z9, Z10, Z11, Z12])


# Solve and plot
# x0 = LVector(X_signal=0)
u0 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
a = 10
b = 10
params = LVector(
    β1=a * 13 + b + 1, κ1=1, α1=1,
    β2=2 * a * 13 + b, κ2=a * 7 + b, α2=1,
    β3=1, κ3=a * 1 + b, κ4=a * 12 + b, α3=1,
    β4=1, κ5=a * 2 + b, κ6=a * 11 + b, α4=1,
    β5=1, κ7=a * 3 + b, κ8=a * 10 + b, α5=1,
    β6=1, κ9=a * 4 + b, κ10=a * 9 + b, α6=1,
    β7=1, κ11=a * 5 + b, κ12=a * 8 + b, α7=1,
    β8=1, κ13=a * 6 + b, κ14=a * 7 + b, α8=1,
    β9=1, κ15=a * 8 + b, κ16=a * 6 + b, α9=1,
    β10=1, κ17=a * 9 + b, κ18=a * 5 + b, α10=1,
    β11=1, κ19=a * 10 + b, κ20=a * 4 + b, α11=1,
    β12=1, κ21=a * 11 + b, κ22=a * 3 + b, α12=1,
    β13=1, κ23=a * 12 + b, κ24=a * 2 + b, α13=1,
    β14=1, κ25=a * 13 + b, κ26=a * 1 + b, α14=1
)
tspan = (0.0, 21.0)

# problem = ODEProblem(final system, u0, tspan, params)
# solution = solve(problem, Tsit5())
problem = ODEProblem(system, u0, tspan, params)
solution = solve(problem, Tsit5())

#plot(sol, rabbitfox_system, params,
#    lw=2, title="Lotka-Volterra Predator-Prey Model",
#    xlabel="time", ylabel="population size"
#)

plot(solution, system, params,
    lw=2,
    title="Motor Flagella Network", titlefontsize=18,
    xlabel="Simulation Time Steps", ylabel="Amount of Transcription Factor",
    size=(1000, 500), margins=10mm
)



