using Documenter, DICE

makedocs()

deploydocs(
    deps   = Deps.pip("mkdocs", "python-markdown-math"),
    repo   = "github.com/Libbum/DICE.jl.git",
    julia  = "0.6"
)
