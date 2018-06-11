using Documenter, DICE

makedocs(
    format = [:html],
    sitename = "DICE.jl",
    authors = "Tim DuBois",
    clean = true,
    pages = [
        "index.md",
        "api.md",
    ]
)

deploydocs(
    repo   = "github.com/Libbum/DICE.jl.git",
    target = "build",
    osname = "linux",
    julia  = "0.6",
    deps   = nothing,
    make   = nothing
)
