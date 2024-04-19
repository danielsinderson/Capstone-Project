#=
Code to support wiring lenses together:
- Lens struct
- Lens composition
- Lens monoidal product
=#


struct Lens
    update::Function
    output::Function
end


function ∘(A::Lens, B::Lens)::Lens
    up_new(a, b)::Function = A.update(a, B.update(A.output(a), b))
    out_new(a)::Function = B.output ∘ A.output
    return Lens(up_new, out_new)
end


function ⊗(A::Lens, B::Lens)::Lens
    up_new((a, c), (b, d))::Function = (A.update(a, b), B.update(c, d))
    out_new((a, c))::Function = (A.output(s1), B.output(s2))
    return Lens(up_new, out_new)
end

