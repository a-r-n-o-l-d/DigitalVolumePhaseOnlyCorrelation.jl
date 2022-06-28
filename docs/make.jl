using DigitalVolumePhaseOnlyCorrelation
using Documenter

DocMeta.setdocmeta!(DigitalVolumePhaseOnlyCorrelation, :DocTestSetup, :(using DigitalVolumePhaseOnlyCorrelation); recursive=true)

makedocs(;
    modules=[DigitalVolumePhaseOnlyCorrelation],
    authors="Arnold",
    repo="https://github.com/a-r-n-o-l-d/DigitalVolumePhaseOnlyCorrelation.jl/blob/{commit}{path}#{line}",
    sitename="DigitalVolumePhaseOnlyCorrelation.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://a-r-n-o-l-d.github.io/DigitalVolumePhaseOnlyCorrelation.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/a-r-n-o-l-d/DigitalVolumePhaseOnlyCorrelation.jl",
    devbranch="main",
)
