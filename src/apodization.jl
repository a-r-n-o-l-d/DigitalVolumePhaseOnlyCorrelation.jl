abstract type ApodizationFunction end

for apod in (:rect, :hanning, :hamming, :cosine, :lanczos, :triang, :bartlett, :bartlett_hann, :blackman)
    st = string(apod)
    uf = uppercasefirst.(split(st, "_"))
    sname = Symbol(*(uf...))
    @eval begin
        """
            $(string($sname))(sz; kwargs...)
            $(string($sname))(sz...; kwargs...)
        Create an apodization function $(string($sname)) up to 3 dimensions,
        with size `sz` defined as a single `Int` (1-dimensionnal), tuple of 
        `Int` or variadic `Int`.

        For `kwargs` see $(string($apod)) function in `DSP.jl`.
        """
        struct $sname{N, T<:Real} <: ApodizationFunction
            weights::Array{T, N}
        end

        $sname(n::Int; kwargs...) = $sname(DSP.$apod(n; kwargs...))

        $sname(sz::Vararg{Int, 2}; kwargs...) = $sname(DSP.$apod(sz; kwargs...))

        function $sname(sz::Vararg{Int, 3}; kwargs...)
            w2d = $sname(sz[1:2]; kwargs...).weights #DSP.$apod(sz[1:2]; kwargs...)
            w3d = $sname(sz[end]; kwargs...).weights #DSP.$apod(sz[end]; kwargs...)
            w = zeros(size(w2d)..., size(w3d)...)
            for k in 1:sz[end]
               @inbounds @. w[:,:,k] = w2d * w3d[k]
            end
            $sname(w)
        end

        $sname(sz::NTuple{N, Int}; kwargs...) where {N} = $sname(sz...; kwargs...)

        (apod::$sname)(A) = @. apod.weights * A
    end
end

#=
struct Hanning{N} <: ApodizationFunction
    weights::Array{<:Real,N}
end

Hanning(n::Int; kwargs...) = Hanning(DSP.hanning(n; kwargs...))

Hanning(sz::Vararg{Int,2}; kwargs...) = Hanning(DSP.hanning(sz; kwargs...))

function Hanning(sz::Vararg{Int,3}; kwargs...)
    w2d = DSP.hanning(sz[1:2]; kwargs...)
    w3d = DSP.hanning(sz[end]; kwargs...)
    w = zeros(size(w2d)..., size(w3d)...)
    for k in 1:sz[end]
       @inbounds @. w[:,:,k] = w2d * w3d[k]
    end
    Hanning(w)
end

function (apod::Hanning)(A)
    @. apod.weights * A
end
=#
