function poc(sig1, sig2)
    c = fft(sig1) .* conj.(fft(sig2))
    real.(ifftshift(ifft(c ./ abs.(c))))
end

poc(sig1::Array{T}, sig2::Array{T}) where {T<:AbstractGray} = poc(channelview(sig1), channelview(sig2))
