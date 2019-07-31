using Documenter, DICE

makedocs(
    modules = [DICE],
    doctest = true,
    format = Documenter.HTML(prettyurls=!("local" in ARGS)),
    sitename = "DICE.jl",
    authors = "Tim DuBois",
    linkcheck = false,
    pages = [
        "Home" => "index.md",
        "API" => "api.md",
    ],
)

deploydocs(
    repo   = "github.com/Libbum/DICE.jl.git",
    target = "build",
    make   = nothing,
    deps   = nothing,
)
