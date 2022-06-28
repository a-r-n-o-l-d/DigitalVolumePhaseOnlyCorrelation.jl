function poc(img1, img2)
    c = fft(img1) .* conj.(fft(img2))
    real.(ifftshift(ifft(c ./ abs.(c))))
end

poc(img1::Array{T}, img2::Array{T}) where {T<:AbstractGray} = poc(channelview(img1), channelview(img2))