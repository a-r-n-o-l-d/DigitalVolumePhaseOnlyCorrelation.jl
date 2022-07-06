module DigitalVolumePhaseOnlyCorrelation

using PhaseOnlyCorrelation


#=
function local_displacement(sig1, sig2, I, winsize, apod)
    Δ = CartesianIndex(winsize .÷ 2)
    s1 = apod(sig1[I - Δ:I + Δ - one(I)])
    s2 = apod(sig2[I - Δ:I + Δ - one(I)])
    displacement(s1, s2)
end
=#

#using DSP
#using Images
#using ImageCore
#using ColorTypes
#using FFTW

#=export  RectApodization,
        HanningApodization,
        HammingApodization,
        CosineApodization,
        LanczosApodization,
        TriangApodization,
        BartlettApodization,
        BartlettHannApodization,
        BlackmanApodization,
        TukeyApodization,
        GaussianApodization,
        KaiserApodization
include("apodization.jl")

export poc, displacement, local_displacement
include("poc.jl")
=#

end
