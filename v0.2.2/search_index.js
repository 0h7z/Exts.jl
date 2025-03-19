var documenterSearchIndex = {"docs":
[{"location":"StatisticsExt/#API-reference","page":"StatisticsExt","title":"API reference","text":"","category":"section"},{"location":"StatisticsExt/","page":"StatisticsExt","title":"StatisticsExt","text":"Modules = [StatisticsExt]\nOrder   = [:module]","category":"page"},{"location":"StatisticsExt/#StatisticsExt.StatisticsExt","page":"StatisticsExt","title":"StatisticsExt.StatisticsExt","text":"StatisticsExt\n\n\n\n\n\n","category":"module"},{"location":"StatisticsExt/#Types","page":"StatisticsExt","title":"Types","text":"","category":"section"},{"location":"StatisticsExt/","page":"StatisticsExt","title":"StatisticsExt","text":"Modules = [StatisticsExt]\nOrder   = [:constant, :type]","category":"page"},{"location":"StatisticsExt/#Functions","page":"StatisticsExt","title":"Functions","text":"","category":"section"},{"location":"StatisticsExt/","page":"StatisticsExt","title":"StatisticsExt","text":"Modules = [StatisticsExt]\nOrder   = [:function, :macro]","category":"page"},{"location":"StatisticsExt/#Exts.nanmean-Tuple{AbstractArray, StatsBase.AbstractWeights}","page":"StatisticsExt","title":"Exts.nanmean","text":"nanmean(A::AbstractArray, w::AbstractWeights; dims = :)\n\nCompute the weighted mean of array A with weight vector w, and fallback to the unweighted mean if w is all zero(s) (instead of returning NaN). If dims (of type Int) is provided, compute the mean along dimension dims.\n\nSee also mean(::AbstractArray), mean(::AbstractArray, ::AbstractWeights).\n\n\n\n\n\n","category":"method"},{"location":"BaseExt/#API-reference","page":"BaseExt","title":"API reference","text":"","category":"section"},{"location":"BaseExt/","page":"BaseExt","title":"BaseExt","text":"Modules = [BaseExt]\nOrder   = [:module]","category":"page"},{"location":"BaseExt/#Exts.BaseExt","page":"BaseExt","title":"Exts.BaseExt","text":"BaseExt\n\n\n\n\n\n","category":"module"},{"location":"BaseExt/#Types","page":"BaseExt","title":"Types","text":"","category":"section"},{"location":"BaseExt/","page":"BaseExt","title":"BaseExt","text":"Modules = [BaseExt]\nOrder   = [:constant, :type]","category":"page"},{"location":"BaseExt/#Functions","page":"BaseExt","title":"Functions","text":"","category":"section"},{"location":"BaseExt/","page":"BaseExt","title":"BaseExt","text":"Modules = [BaseExt]\nOrder   = [:function, :macro]","category":"page"},{"location":"BaseExt/#Base.log10-Union{Tuple{T}, Tuple{T, T}} where T<:Real","page":"BaseExt","title":"Base.log10","text":"log10(x::T, σ::T) -> NTuple{2, AbstractFloat} where T <: Real\n\nCompute the logarithm of x ± σ to base 10.\n\n\n\n\n\n","category":"method"},{"location":"FITSIOExt/#API-reference","page":"FITSIOExt","title":"API reference","text":"","category":"section"},{"location":"FITSIOExt/","page":"FITSIOExt","title":"FITSIOExt","text":"Modules = [FITSIOExt]\nOrder   = [:module]","category":"page"},{"location":"FITSIOExt/#FITSIOExt.FITSIOExt","page":"FITSIOExt","title":"FITSIOExt.FITSIOExt","text":"FITSIOExt\n\n\n\n\n\n","category":"module"},{"location":"FITSIOExt/#Types","page":"FITSIOExt","title":"Types","text":"","category":"section"},{"location":"FITSIOExt/","page":"FITSIOExt","title":"FITSIOExt","text":"Modules = [FITSIOExt]\nOrder   = [:constant, :type]","category":"page"},{"location":"FITSIOExt/#FITSIO.EitherTableHDU","page":"FITSIOExt","title":"FITSIO.EitherTableHDU","text":"FITSIO.EitherTableHDU = Union{ASCIITableHDU, TableHDU}\n\n\n\n\n\n","category":"type"},{"location":"FITSIOExt/#Functions","page":"FITSIOExt","title":"Functions","text":"","category":"section"},{"location":"FITSIOExt/","page":"FITSIOExt","title":"FITSIOExt","text":"Modules = [FITSIOExt]\nOrder   = [:function, :macro]","category":"page"},{"location":"FITSIOExt/#Base.read","page":"FITSIOExt","title":"Base.read","text":"read(t::FITSIO.EitherTableHDU, DataFrame,\n\tcolnames = Tables.columnnames(t)) -> DataFrame\n\nRead a DataFrame from the given ASCIITableHDU or TableHDU.\n\n\n\n\n\n","category":"function"},{"location":"DataFramesExt/#API-reference","page":"DataFramesExt","title":"API reference","text":"","category":"section"},{"location":"DataFramesExt/","page":"DataFramesExt","title":"DataFramesExt","text":"Modules = [DataFramesExt]\nOrder   = [:module]","category":"page"},{"location":"DataFramesExt/#DataFramesExt.DataFramesExt","page":"DataFramesExt","title":"DataFramesExt.DataFramesExt","text":"DataFramesExt\n\n\n\n\n\n","category":"module"},{"location":"DataFramesExt/#Types","page":"DataFramesExt","title":"Types","text":"","category":"section"},{"location":"DataFramesExt/","page":"DataFramesExt","title":"DataFramesExt","text":"Modules = [DataFramesExt]\nOrder   = [:constant, :type]","category":"page"},{"location":"DataFramesExt/#Functions","page":"DataFramesExt","title":"Functions","text":"","category":"section"},{"location":"DataFramesExt/","page":"DataFramesExt","title":"DataFramesExt","text":"Modules = [DataFramesExt]\nOrder   = [:function, :macro]","category":"page"},{"location":"DataFramesExt/#Base.read","page":"DataFramesExt","title":"Base.read","text":"read(s::IOStream, DataFrame, colnames = nothing;\n\tquotes = true, comments = true, comment_char = '#') -> DataFrame\n\nRead a DataFrame from the given I/O stream or file where each line gives one row.\n\nIf colnames is not provided (or, is nothing), the first row of data will be read as header. If colnames is the symbol :auto, the column names will be x1, x2, and so on. Otherwise, colnames must be a vector of symbols or strings to specify column names.\n\nIf quotes is true, columns enclosed within double-quote (\") characters are allowed to contain new lines and column delimiters. Double-quote characters within a quoted field must be escaped with another double-quote.\n\nIf comments is true, lines beginning with comment_char and text following comment_char in any line are ignored.\n\n\n\n\n\n","category":"function"},{"location":"DataFramesExt/#Base.read-Tuple{AbstractString, Type{DataFrames.DataFrame}, Vararg{Any}}","page":"DataFramesExt","title":"Base.read","text":"read(f::AbstractString, DataFrame, colnames = nothing;\n\tquotes = true, comments = true, comment_char = '#') -> DataFrame\n\nRead a DataFrame from the given I/O stream or file where each line gives one row.\n\nIf colnames is not provided (or, is nothing), the first row of data will be read as header. If colnames is the symbol :auto, the column names will be x1, x2, and so on. Otherwise, colnames must be a vector of symbols or strings to specify column names.\n\nIf quotes is true, columns enclosed within double-quote (\") characters are allowed to contain new lines and column delimiters. Double-quote characters within a quoted field must be escaped with another double-quote.\n\nIf comments is true, lines beginning with comment_char and text following comment_char in any line are ignored.\n\n\n\n\n\n","category":"method"},{"location":"DataFramesExt/#Base.write-Tuple{AbstractString, DataFrames.AbstractDataFrame}","page":"DataFramesExt","title":"Base.write","text":"write(f::AbstractString, x::AbstractDataFrame; delim = '\\t', header = true) -> Int64\n\nWrite a DataFrame as text to the given I/O stream or file, using the given delimiter delim (which defaults to tab, but can be anything printable, typically a character or string).\n\nReturn the number of bytes written into the stream or file.\n\n\n\n\n\n","category":"method"},{"location":"DataFramesExt/#Base.write-Tuple{IOStream, DataFrames.AbstractDataFrame}","page":"DataFramesExt","title":"Base.write","text":"write(s::IOStream, x::AbstractDataFrame; delim = '\\t', header = true) -> Int64\n\nWrite a DataFrame as text to the given I/O stream or file, using the given delimiter delim (which defaults to tab, but can be anything printable, typically a character or string).\n\nReturn the number of bytes written into the stream or file.\n\n\n\n\n\n","category":"method"},{"location":"#Exts.jl","page":"Manual","title":"Exts.jl","text":"","category":"section"},{"location":"","page":"Manual","title":"Manual","text":"(Image: CI status) (Image: codecov.io)","category":"page"},{"location":"","page":"Manual","title":"Manual","text":"","category":"page"},{"location":"#Usage","page":"Manual","title":"Usage","text":"","category":"section"},{"location":"","page":"Manual","title":"Manual","text":"pkg> registry add https://github.com/0h7z/0hjl.git\npkg> add Exts\n\njulia> using Exts","category":"page"},{"location":"","page":"Manual","title":"Manual","text":"","category":"page"},{"location":"#API-reference","page":"Manual","title":"API reference","text":"","category":"section"},{"location":"","page":"Manual","title":"Manual","text":"Modules = [Exts]\nOrder   = [:module]","category":"page"},{"location":"#Types","page":"Manual","title":"Types","text":"","category":"section"},{"location":"","page":"Manual","title":"Manual","text":"Modules = [Exts]\nOrder   = [:constant, :type]","category":"page"},{"location":"#Exts.Datum","page":"Manual","title":"Exts.Datum","text":"Datum{T} -> Union{T, Missing}\ndatum(T::Type...) -> Datum{Union{T...}}\n\n\n\n\n\n","category":"type"},{"location":"#Exts.IntOrStr","page":"Manual","title":"Exts.IntOrStr","text":"IntOrStr -> Union{AbstractString, Integer}\n\n\n\n\n\n","category":"type"},{"location":"#Exts.Maybe","page":"Manual","title":"Exts.Maybe","text":"Maybe{T} -> Union{T, Nothing}\nmaybe(T::Type...) -> Maybe{Union{T...}}\n\n\n\n\n\n","category":"type"},{"location":"#Exts.SymOrStr","page":"Manual","title":"Exts.SymOrStr","text":"SymOrStr -> Union{AbstractString, Symbol}\n\n\n\n\n\n","category":"type"},{"location":"#Exts.VecOrTup","page":"Manual","title":"Exts.VecOrTup","text":"VecOrTup -> Union{AbstractVector, Tuple}\n\n\n\n\n\n","category":"type"},{"location":"#Exts.LDict","page":"Manual","title":"Exts.LDict","text":"LDict -> LittleDict\n\n\n\n\n\n","category":"type"},{"location":"#Exts.ODict","page":"Manual","title":"Exts.ODict","text":"ODict -> OrderedDict\n\n\n\n\n\n","category":"type"},{"location":"#Exts.OSet","page":"Manual","title":"Exts.OSet","text":"OSet  -> OrderedSet\n\n\n\n\n\n","category":"type"},{"location":"#Exts.UDict","page":"Manual","title":"Exts.UDict","text":"UDict -> Dict # UnorderedDict\n\n\n\n\n\n","category":"type"},{"location":"#Exts.USet","page":"Manual","title":"Exts.USet","text":"USet  -> Set  # UnorderedSet\n\n\n\n\n\n","category":"type"},{"location":"#Exts.VTuple","page":"Manual","title":"Exts.VTuple","text":"VTuple{T} -> Tuple{Vararg{T}}\n\n\n\n\n\n","category":"type"},{"location":"#Exts.VTuple1","page":"Manual","title":"Exts.VTuple1","text":"VTuple1{T} -> Tuple{T, Vararg{T}}\n\n\n\n\n\n","category":"type"},{"location":"#Functions","page":"Manual","title":"Functions","text":"","category":"section"},{"location":"","page":"Manual","title":"Manual","text":"Modules = [Exts]\nOrder   = [:function, :macro]","category":"page"},{"location":"#Exts.cis-Tuple{Real}","page":"Manual","title":"Exts.cis","text":"Exts.cis(x::Real) -> Complex{<:AbstractFloat}\n\nMore accurate method for exp(im*x) (especially for large x).\n\nSee also ∠, polar, Base.cis, cispi.\n\nExamples\n\njulia> -1 == -Exts.cis(2π) == Exts.cis(-π) == Exts.cis(π)\ntrue\n\njulia> -1 != -Base.cis(2π) != Base.cis(-π) != Base.cis(π)\ntrue\n\n\n\n\n\n","category":"method"},{"location":"#Exts.datum","page":"Manual","title":"Exts.datum","text":"Datum{T} -> Union{T, Missing}\ndatum(T::Type...) -> Datum{Union{T...}}\n\n\n\n\n\n","category":"function"},{"location":"#Exts.ext-Tuple{Colon}","page":"Manual","title":"Exts.ext","text":"Exts.ext(::Colon) -> VTuple{Pair{Symbol, Maybe{Module}}}\n\n\n\n\n\n","category":"method"},{"location":"#Exts.ext-Tuple{Symbol}","page":"Manual","title":"Exts.ext","text":"Exts.ext(x::Symbol) -> Maybe{Module}\n\n\n\n\n\n","category":"method"},{"location":"#Exts.invsqrt-Tuple{T} where T<:Real","page":"Manual","title":"Exts.invsqrt","text":"invsqrt(x::T) -> AbstractFloat where T <: Real\n\nReturn sqrtx^-1.\n\nSee also sqrt.\n\nExamples\n\njulia> invsqrt(4)\n0.5\n\n\n\n\n\n","category":"method"},{"location":"#Exts.isdir-Tuple{AbstractString}","page":"Manual","title":"Exts.isdir","text":"Exts.isdir(path::AbstractString) -> Bool\n\nReturn true if path is a directory, false otherwise.\n\nExamples\n\njulia> Exts.isdir(homedir())\ntrue\n\njulia> Exts.isdir(\"not/a/directory\")\nfalse\n\nSee also isfile and ispath.\n\n\n\n\n\n","category":"method"},{"location":"#Exts.isdirpath-Tuple{AbstractString}","page":"Manual","title":"Exts.isdirpath","text":"Exts.isdirpath(path::AbstractString) -> Bool\n\nDetermine whether a path refers to a directory (for example, ends with a path separator).\n\nExamples\n\njulia> Exts.isdirpath(\"/home\")\nfalse\n\njulia> Exts.isdirpath(\"/home/\")\ntrue\n\n\n\n\n\n","category":"method"},{"location":"#Exts.lmap","page":"Manual","title":"Exts.lmap","text":"lmap(f, iterators...)\n\nCreate a lazy mapping. This is another syntax for writing (f(args...) for args in zip(iterators...)). Equivalent to Iterators.map.\n\nSee also map.\n\nExamples\n\njulia> collect(lmap(x -> x^2, 1:3))\n3-element Vector{Int64}:\n 1\n 4\n 9\n\n\n\n\n\n","category":"function"},{"location":"#Exts.maybe","page":"Manual","title":"Exts.maybe","text":"Maybe{T} -> Union{T, Nothing}\nmaybe(T::Type...) -> Maybe{Union{T...}}\n\n\n\n\n\n","category":"function"},{"location":"#Exts.notmissing-Tuple{Any}","page":"Manual","title":"Exts.notmissing","text":"notmissing(x)\n\nThrow an error if x === missing, and return x if not.\n\nSee also notnothing.\n\n\n\n\n\n","category":"method"},{"location":"#Exts.polar-Tuple{Real, Real}","page":"Manual","title":"Exts.polar","text":"polar(radius::Real, azimuth::Real) -> Complex{<:AbstractFloat}\n\nReturn rθ, where θ is in degrees. Equivalent to radius∠(azimuth).\n\nSee also ∠.\n\n\n\n\n\n","category":"method"},{"location":"#Exts.readstr-Tuple{Any}","page":"Manual","title":"Exts.readstr","text":"readstr(x) -> String\n\nRead the entirety of x as a string. Equivalent to read(x, String).\n\nSee also read, readchomp.\n\n\n\n\n\n","category":"method"},{"location":"#Exts.stdpath-Tuple{AbstractString, Vararg{AbstractString}}","page":"Manual","title":"Exts.stdpath","text":"stdpath(path::AbstractString...; real = false) -> String\n\nStandardize a path (or a set of paths, by joining them together), removing \".\" and \"..\" entries and changing path separator to the standard \"/\".\n\nIf path is a directory, the returned path will end with a \"/\".\n\nIf real is true, symbolic links are expanded, however the path must exist in the filesystem. On case-insensitive case-preserving filesystems, the filesystem's stored case for the path is returned.\n\nExamples\n\njulia> stdpath(\"/home/myuser/../example.jl\")\n\"/home/example.jl\"\n\njulia> stdpath(\"Documents\\\\Julia\\\\\")\n\"Documents/Julia/\"\n\n\n\n\n\n","category":"method"},{"location":"#Exts.∠-Tuple{Real}","page":"Manual","title":"Exts.∠","text":"∠(azimuth::Real) -> Complex{<:AbstractFloat}\n\nReturn 1θ, where θ is in degrees. Equivalent to polar(1, azimuth).\n\nSee also polar, Exts.cis.\n\n\n\n\n\n","category":"method"},{"location":"#Exts.@catch-Tuple{Any}","page":"Manual","title":"Exts.@catch","text":"@catch expr\n\nEvaluate the expression with a try/catch construct and return the thrown exception. If no error (exception) occurs, return nothing.\n\nSee also The-try/catch-statement, try/catch, @trycatch, @try.\n\n\n\n\n\n","category":"macro"},{"location":"#Exts.@noinfo-Tuple{Any}","page":"Manual","title":"Exts.@noinfo","text":"@noinfo expr\n\nSuppress all lexically-enclosed uses of @debug, @info.\n\n\n\n\n\n","category":"macro"},{"location":"#Exts.@nowarn-Tuple{Any}","page":"Manual","title":"Exts.@nowarn","text":"@nowarn expr\n\nSuppress all lexically-enclosed uses of @debug, @info, @warn.\n\n\n\n\n\n","category":"macro"},{"location":"#Exts.@try","page":"Manual","title":"Exts.@try","text":"@try expr default = nothing\n\nEvaluate the expression with a try/catch construct and return the result. If any error (exception) occurs, return default.\n\nSee also The-try/catch-statement, try/catch, @trycatch, @catch.\n\n\n\n\n\n","category":"macro"},{"location":"#Exts.@trycatch-Tuple{Any}","page":"Manual","title":"Exts.@trycatch","text":"@trycatch expr\n\nEvaluate the expression with a try/catch construct and return either the result or the thrown exception, whichever available.\n\nSee also The-try/catch-statement, try/catch, @try, @catch.\n\n\n\n\n\n","category":"macro"}]
}
