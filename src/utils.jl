localdisp(sig1, sig2, I, apod, subix) = localdisp(sig1, sig2, I, I, apod, subix)

function localdisp(sig1, sig2, I1, I2, apod, subix)
    Δ = CartesianIndex(size(apod) .÷ 2)
    s1 = apod(sig1[I1 - Δ:I1 + Δ - one(I1)])
    s2 = apod(sig2[I2 - Δ:I2 + Δ - one(I2)])
    displacement(s1, s2, apod, subix)
end

function refinedisp(img1, img2, I1, Δ, apod, subpix)
    Δi = round.(Int, Δ)
    I2 = I1 + CartesianIndex(Δi)
    Δest, cor = localdisp(img1, img2, I1, I2, apod, subpix)
    (Δi .+ Δest), cor
end