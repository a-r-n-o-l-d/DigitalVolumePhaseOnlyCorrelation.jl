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

function padsignals(sig1, sig2, win1, win2, Δinit, pad)
    spad = @. (win1 + win2) ÷ 2 + abs(round(Int, Δinit))
    if pad == :fill0
        im1 = padarray(img1, Fill(zero(eltype(img1)), spad))
        im2 = padarray(img2, Fill(zero(eltype(img2)), spad))
    else
        im1 = padarray(img1, Pad(pad, sz))
        im2 = padarray(img2, Pad(pad, sz))
    end
    im1, im2
end