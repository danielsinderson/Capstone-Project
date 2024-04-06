
include("Lenses.jl")


function build_state_machine(dynamics::Dict)::Lens
    update(s) = dynamics[s]
    output(s) = s
    return Lens(update, output)
end


m1 = Dict(0 => 1, 1 => 2, 2 => 3, 3 => 0)
m2 = Dict(0 => 2, 1 => 0, 2 => 1)

machine1::Lens = build_state_machine(m1)
machine2::Lens = build_state_machine(m2)

total_machine::Lens = machine2 ∘ machine2
