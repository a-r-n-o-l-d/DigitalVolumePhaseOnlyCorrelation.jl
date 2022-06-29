abstract type ApodizationFunction end

for apod in (:rect, :hanning, :hamming, :cosine, :lanczos, :triang, :bartlett, :bartlett_hann, :blackman)
    st = string(apod)
    uf = uppercasefirst.(split(st, "_"))
    sname = Symbol(*(uf...))
    @eval begin
        """
            $(string($sname))(sz; kwargs...)
        Create an apodization function `$(string($sname))` up to 3 dimensions,
        with size `sz` defined as a single `Int` (1-dimensionnal) or a tuple of 
        `Int`.

        For `kwargs` definitions see `$(string($apod))` function in package
        `DSP.jl`.

        # Example

        ```jldoctest
        julia> apod = Hanning((4, 4, 4));

        julia> A = rand(4, 4, 4);
        
        julia> apod(A)
        4×4×4 Array{Float64, 3}:
        [:, :, 1] =
         0.0  0.0  0.0  0.0
         0.0  0.0  0.0  0.0
         0.0  0.0  0.0  0.0
         0.0  0.0  0.0  0.0
        
        [:, :, 2] =
         0.0  0.0       0.0        0.0
         0.0  0.212389  0.314747   0.0
         0.0  0.297712  0.0613367  0.0
         0.0  0.0       0.0        0.0
        
        [:, :, 3] =
         0.0  0.0       0.0       0.0
         0.0  0.350347  0.041379  0.0
         0.0  0.352027  0.399866  0.0
         0.0  0.0       0.0       0.0
        
        [:, :, 4] =
         0.0  0.0  0.0  0.0
         0.0  0.0  0.0  0.0
         0.0  0.0  0.0  0.0
         0.0  0.0  0.0  0.0
        ```
        """
        struct $sname{N, T<:Real} <: ApodizationFunction
            weights::Array{T, N}
        end

        $sname(n::Int; kwargs...) = $sname(DSP.$apod(n; kwargs...))

        $sname(sz::NTuple{2, Int}; kwargs...) = $sname(DSP.$apod(sz; kwargs...))

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

for apod in (:tukey, :gaussian, :kaiser)
    sname = Symbol(uppercasefirst(string(apod)))
    @eval begin
        """
            $(string($sname))(sz, par; kwargs...)
        Create an apodization function `$(string($sname))` up to 3 dimensions,
        with size `sz` defined as a single `Int` (1-dimensionnal) or a tuple of 
        `Int`.

        For `par` and `kwargs` definitions see `$(string($apod))` function in 
        package `DSP.jl`.

        # Example

        ```jldoctest
        julia> apod = Tukey((4, 4, 4), 0.5);

        julia> A = rand(4, 4, 4);
        
        julia> apod(A)
        4×4×4 Array{Float64, 3}:
        [:, :, 1] =
         0.0  0.0  0.0  0.0
         0.0  0.0  0.0  0.0
         0.0  0.0  0.0  0.0
         0.0  0.0  0.0  0.0
        
        [:, :, 2] =
         0.0  0.0       0.0        0.0
         0.0  0.699249  0.562785   0.0
         0.0  0.602818  0.0661816  0.0
         0.0  0.0       0.0        0.0
        
        [:, :, 3] =
         0.0  0.0       0.0       0.0
         0.0  0.824524  0.975829  0.0
         0.0  0.287927  0.816005  0.0
         0.0  0.0       0.0       0.0
        
        [:, :, 4] =
         0.0  0.0  0.0  0.0
         0.0  0.0  0.0  0.0
         0.0  0.0  0.0  0.0
         0.0  0.0  0.0  0.0
        ```
        """
        struct $sname{N, T<:Real} <: ApodizationFunction
            weights::Array{T, N}
        end

        $sname(n::Int, par; kwargs...) = $sname(DSP.$apod(n, par; kwargs...))

        $sname(sz::NTuple{2, Int}, par; kwargs...) = $sname(DSP.$apod(sz, par; kwargs...))

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
