using Documenter, DICE

DocMeta.setdocmeta!(DICE, :DocTestSetup, :(using DICE); recursive=true)

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
)
