#	Exts.jl
[![CI status](https://github.com/0h7z/Exts.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/0h7z/Exts.jl/actions/workflows/CI.yml)
[![codecov.io](https://codecov.io/gh/0h7z/Exts.jl/branch/master/graph/badge.svg)](https://app.codecov.io/gh/0h7z/Exts.jl)

*****
##	Usage
```julia-repl
pkg> registry add https://github.com/0h7z/0hjl.git
pkg> add Exts
```

```julia
julia> using Exts

julia> Exts.ext(:) # to see which extensions are loaded
7-element Vector{Pair{Symbol, Union{Nothing, Module}}}:
       :BaseExt => Exts.BaseExt
 :DataFramesExt => DataFramesExt
      :DatesExt => DatesExt
     :FITSIOExt => FITSIOExt
        :PkgExt => Exts.PkgExt
 :StatisticsExt => StatisticsExt
       :YAMLExt => YAMLExt
```

