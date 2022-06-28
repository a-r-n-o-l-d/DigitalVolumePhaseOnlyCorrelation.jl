wsz = 16

for func in (:rect, :hanning, :hamming, :cosine, :lanczos, :triang, :bartlett, :bartlett_hann, :blackman)
    st = string(func)
    uf = uppercasefirst.(split(st, "_"))
    sname = Symbol(*(uf...))
    @eval begin
        apod = $sname(wsz)
        @test all(apod.weights .== DSP.$func(wsz))

        apod = $sname((wsz, wsz))
        @test all(apod.weights .== DSP.$func((wsz, wsz)))

        A = rand(wsz, wsz, wsz)
        res = similar(A)
        w = DSP.$func(wsz)
        for k in 1:wsz, j in 1:wsz, i in 1:wsz
            res[i, j, k] = A[i, j, k] * w[i] * w[j] * w[k]
        end
        apod = $sname((wsz, wsz, wsz))
        @test all(apod(A) .≈ res)
    end
end
