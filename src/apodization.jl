abstract type ApodizationFunction end

for func in (:rect, :hanning, :hamming, :cosine, :lanczos, :triang, :bartlett, :bartlett_hann, :blackman)
    st = string(func)
    uf = uppercasefirst.(split(st, "_"))
    sname = Symbol(*(uf..., "Apodization"))
    @eval begin
        """
            $(string($sname))(sz; kwargs...)
        Create an apodization function `$(string($sname))` up to 3 dimensions,
        with size `sz` defined as a single `Int` (1-dimensionnal) or a tuple of 
        `Int`.

        For `kwargs` definitions see `$($st)` function in package 
        `DSP.jl`.

        # Example

        ```julia
        julia> apod = $(string($sname))((4, 4, 4));

        julia> A = rand(4, 4, 4);
        
        julia> apod(A)
        4×4×4 Array{Float64, 3}:
        ...
        ```
        """
        struct $sname{N, T<:Real} <: ApodizationFunction
            weights::Array{T, N}
        end

        $sname(n::Int; kwargs...) = $sname(DSP.$func(n; kwargs...))

        $sname(sz::NTuple{2, Int}; kwargs...) = $sname(DSP.$func(sz; kwargs...))

        function $sname(sz::NTuple{3, Int}; kwargs...)
            w2d = $sname(sz[1:2]; kwargs...).weights
            w3d = $sname(sz[end]; kwargs...).weights
            w = zeros(size(w2d)..., size(w3d)...)
            for k in 1:sz[end]
                @inbounds @. w[:,:,k] = w2d * w3d[k]
            end
            $sname(w)
        end

        (apod::$sname)(A) = @. apod.weights * A
    end
end

for func in (:tukey, :gaussian, :kaiser)
    st = string(func)
    sname = Symbol("$(uppercasefirst(string(func)))Apodization")
    @eval begin
        """
            $(string($sname))(sz, par; kwargs...)
        Create an apodization function `$(string($sname))` up to 3 dimensions,
        with size `sz` defined as a single `Int` (1-dimensionnal) or a tuple of 
        `Int`.

        For `par` and `kwargs` definitions see `$($st)` function in package 
        `DSP.jl`.

        # Example

        ```julia
        julia> apod = $(string($sname))((4, 4, 4), 0.5);

        julia> A = rand(4, 4, 4);
        
        julia> apod(A)
        4×4×4 Array{Float64, 3}:
        ...
        ```
        """
        struct $sname{N, T<:Real} <: ApodizationFunction
            weights::Array{T, N}
        end

        $sname(n::Int, par; kwargs...) = $sname(DSP.$func(n, par; kwargs...))

        $sname(sz::NTuple{2, Int}, par; kwargs...) = $sname(DSP.$func(sz, par; kwargs...))

        function $sname(sz::NTuple{3, Int}, par; kwargs...)
            w2d = $sname(sz[1:2], par; kwargs...).weights
            w3d = $sname(sz[end], par; kwargs...).weights
            w = zeros(size(w2d)..., size(w3d)...)
            for k in 1:sz[end]
               @inbounds @. w[:,:,k] = w2d * w3d[k]
            end
            $sname(w)
        end

        (apod::$sname)(A) = @. apod.weights * A
    end
end
