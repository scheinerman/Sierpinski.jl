module Sierpinski

using Plots, SimpleDrawing, ProgressMeter

import SimpleDrawing: draw


export Square, Triangle, draw, children, gray_draw

struct Square
    x::Float64    # lower left x-coordinate
    y::Float64    # lower left y-coordinate
    s::Float64    # side length

    function Square(xx = 0, yy = 0, ss = 1)
        new(xx, yy, ss)
    end
end

struct Triangle
    x::Float64    # lower left x-coordinate
    y::Float64    # lower left y-coordinate
    s::Float64    # side length

    function Triangle(xx = 0, yy = 0, ss = 1)
        new(xx, yy, ss)
    end
end



function draw(S::Square; opts...)
    x = S.x
    y = S.y
    s = S.s

    xx = [x; x + s; x + s; x]
    yy = [y; y; y + s; y + s]

    X = Shape(xx, yy)
    plot!(X; opts...)
end



function draw(T::Triangle; opts...)
    x = T.x
    y = T.y
    s = T.s

    xx = [x; x + s; x + s / 2]
    yy = [y; y; y + s * sqrt(3) / 2]

    X = Shape(xx, yy)
    plot!(X; opts...)
end


"""
    children(T::Triangle)

Return a list of the three "children" of this triangle: 
half-sized versions at the appropriate coordinates.
"""
function children(T::Triangle)::Vector{Triangle}
    x = T.x
    y = T.y
    s = T.s

    T1 = Triangle(x, y, s / 2)
    T2 = Triangle(x + s / 2, y, s / 2)
    T3 = Triangle(x + s / 4, y + s * sqrt(3) / 4, s / 2)

    return [T1, T2, T3]
end

function children(S::Square)::Vector{Square}
    x = S.x
    y = S.y
    s = S.s

    ss = s / 3

    S1 = Square(x, y, ss)
    S2 = Square(x + ss, y, ss)
    S3 = Square(x + 2ss, y, ss)

    S4 = Square(x, y + ss, ss)
    S5 = Square(x + 2ss, y + ss, ss)

    S6 = Square(x, y + 2ss, ss)
    S7 = Square(x + ss, y + 2ss, ss)
    S8 = Square(x + 2ss, y + 2ss, ss)

    return [S1, S2, S3, S4, S5, S6, S7, S8]
end

function children(X::T, steps::Int = 1)::Vector{T} where {T<:Union{Triangle,Square}}

    @assert steps >= 0 "steps must be nonnegative"

    if steps == 0
        return [X]
    end
    if steps == 1
        return children(X)
    end

    XX = children(X, steps - 1)

    result = T[]
    for A in XX
        result = vcat(result, children(A))
    end
    return result
end


"""
    gray_draw(X::T) where T<:Union{Triangle,Square}

Draw `X` in light gray (fill and boundary).
"""
function gray_draw(X::T) where {T<:Union{Triangle,Square}}
    draw(X, linewidth=0, color = :lightgray)
end


export triangle_pic, carpet_pic

"""
    triangle_pic(depth::Int = 6)

Generate picture of Sierpinski's triangle.
"""
function triangle_pic(depth::Int = 6)
    @info "Generating triangles to depth $depth"
    T = Triangle()
    TT = children(T, depth)
    n = length(TT)
    @info "$n triangles generated"
    newdraw()
    P = Progress(n)
    for x in TT
        next!(P)
        draw(x,linewidth=0, color=:lightgray)
    end
    finish()
end


"""
    carpet_pic(depth::Int = 4)

Generate picture of Sierpinski's carpet.
"""
function carpet_pic(depth::Int = 4)
    @info "Generating squares to depth $depth"
    T = Square()
    TT = children(T, depth)
    n = length(TT)
    @info "$n squares generated"
    P = Progress(n)
    newdraw()
    for x in TT
        next!(P)
        draw(x,linewidth=0, linecolor=:lightgray, color=:lightgray)
    end
    finish()
end


end # module Sierpinski
