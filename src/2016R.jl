struct V2016R <: Version end

Base.show(io::IO, v::V2016R) = print(io, "v2016R")

function v2016R()
    V2016R()
end

export v2016R
