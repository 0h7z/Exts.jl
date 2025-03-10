# Copyright (C) 2023-2025 Heptazhou <zhou@0h7z.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, version 3.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

"""
	Exts.cis(x::Real) -> Complex{<:AbstractFloat}

More accurate method for `exp(im*x)` (especially for large x).

See also [`∠`](@ref), [`polar`](@ref), [`Base.cis`](@extref),
[`cispi`](@extref Base.cispi).

# Examples
```jldoctest
julia> -1 == -Exts.cis(2π) == Exts.cis(-π) == Exts.cis(π)
true

julia> -1 != -Base.cis(2π) != Base.cis(-π) != Base.cis(π)
true
```
"""
function cis(theta::Real)::Complex{<:AbstractFloat}
	@specialize
	cispi(theta / π)
end

"""
	Exts.ext(::Colon) -> Vector{Pair{Symbol, Maybe{Module}}}
"""
function ext(::Colon)::Vector{Pair{Symbol, Maybe{Module}}}
	# using DataFrames, Dates, Exts, FITSIO, StatsBase, YAML
	xs = (
		:Base,
		:DataFrames,
		:Dates,
		:FITSIO, :FITSIODataFrames,
		:Pkg,
		:Statistics,
		:YAML,
		# :PythonCall,
	)
	collect(x => ext(x) for x ∈ xs)
end
"""
	Exts.ext(x::Symbol) -> Maybe{Module}
"""
function ext(x::Symbol, xs::Symbol...)::Maybe{Module}
	x ≡ :Base ? BaseExt :
	x ≡ :Pkg  ? PkgExt  :
	Base.get_extension(@__MODULE__, Symbol(x, xs..., :Ext))
end

"""
	freeze(d::AbstractDict{K, V}) where {K, V} -> LDict{<:K, <:V}

Render a dictionary immutable by converting it to a `Tuple`-backed
[`LittleDict`](@ref LDict). The `Tuple`-backed `LittleDict` is faster than
the `Vector`-backed `LittleDict`, particularly when the keys are all
concretely typed.
"""
function freeze(d::AbstractDict{K, V})::AbstractDict where {K, V}
	OrderedCollections.freeze(d)::FrozenLittleDict{<:K, <:V}
	# https://github.com/JuliaCollections/OrderedCollections.jl/blob/master/src/little_dict.jl
end

"""
	invsqrt(x::T) where T <: Real -> AbstractFloat

Return ``\\sqrt{x^{-1}}``.

See also [`sqrt`](@extref Base.sqrt-Tuple{Number}).

# Examples
```jldoctest
julia> invsqrt(4)
0.5
```
"""
function invsqrt(x::T)::AbstractFloat where T <: Real
	@specialize
	F::Type = float(T)
	F(sqrt(inv(big(x))))::F
end

"""
	Exts.isdir(path::AbstractString) -> Bool

Return `true` if `path` is a directory, `false` otherwise.

# Examples
```jldoctest
julia> Exts.isdir(homedir())
true

julia> Exts.isdir("not/a/directory")
false
```

See also [`isfile`](@extref Base.Filesystem.isfile) and [`ispath`](@extref
Base.Filesystem.ispath).
"""
function isdir(path::AbstractString)::Bool
	p = slash(path)
	r = Base.isdir(p)
	@static !Sys.iswindows() ? r : r =
		!r || !contains(p, r"(?:^|/)\.{3,}(?:/|$)"s) ? r :
		@try pwd() ≠ cd(pwd, p) ≠ realpath("/") false
end

"""
	Exts.isdirpath(path::AbstractString) -> Bool

Determine whether a path refers to a directory (for example, ends with a path
separator).

# Examples
```jldoctest
julia> Exts.isdirpath("/home")
false

julia> Exts.isdirpath("/home/")
true
```
"""
function isdirpath(path::AbstractString)::Bool
	path == "" && return false
	Base.isdirpath(path)
end

"""
	lmap(f, iterators...)

Create a lazy mapping. This is another syntax for writing `(f(args...) for
args in zip(iterators...))`. Equivalent to [`Iterators.map`](@extref
Base.Iterators.map).

See also [`map`](@extref Base.map).

# Examples
```jldoctest
julia> collect(lmap(x -> x^2, 1:3))
3-element Vector{Int64}:
 1
 4
 9
```
"""
lmap = Iterators.map

"""
	notmissing(x)

Throw an error if `x === missing`, and return `x` if not.

See also [`notnothing`](@extref Base.notnothing).
"""
notmissing(x::Any) = x
notmissing(::Missing) = throw(ArgumentError("missing passed to notmissing"))

"""
	polar(radius::Real, azimuth::Real) -> Complex{<:AbstractFloat}

Return ``r∠θ``, where ``θ`` is in degrees. Equivalent to `radius∠(azimuth)`.

See also [`∠`](@ref).
"""
function polar(radius::Real, azimuth::Real)::Complex{<:AbstractFloat}
	@specialize
	cispi(azimuth / 180) * radius
end
"""
	∠(azimuth::Real) -> Complex{<:AbstractFloat}

Return ``1∠θ``, where ``θ`` is in degrees. Equivalent to `polar(1, azimuth)`.

See also [`polar`](@ref), [`Exts.cis`](@ref).
"""
function ∠(azimuth::Real)::Complex{<:AbstractFloat}
	@specialize
	cispi(azimuth / 180) # 360° = 2π rad
end

"""
	readstr(x) -> String

Read the entirety of `x` as a string. Equivalent to `read(x, String)`.

See also [`read`](@extref Base.read), [`readchomp`](@extref Base.readchomp).
"""
readstr(x)::String = read(x, String)

"""
	stdpath(path::AbstractString...; real = false) -> String

Standardize a path (or a set of paths, by joining them together), removing
"." and ".." entries and changing path separator to the standard "/".

If `path` is a directory, the returned path will end with a "/".

If `real` is true, symbolic links are expanded, however the `path` must exist
in the filesystem. On case-insensitive case-preserving filesystems, the
filesystem's stored case for the path is returned.

# Examples
```jldoctest
julia> stdpath("/home/user/../example.jl")
"/home/example.jl"

julia> stdpath("Documents\\\\Julia\\\\")
"Documents/Julia/"
```
"""
function stdpath(path::AbstractString, paths::AbstractString...; real::Bool = false)::String
	p = joinpath(path, paths...)
	p = !isempty(p) ? normpath(p) : return p
	a = isabspath(p)
	d = isdirpath(p) || isdir(p)
	p = real ? realpath(p) : p
	p = !a ? relpath(p) : p
	p = slash(p)
	p = !d || endswith(p, '/') ? p : p * '/'
end

"""
	Exts.walkdir(path::AbstractString = pwd(); topdown = true) -> Channel

Return an iterator that walks the directory tree of a directory.

The iterator returns a tuple containing `(path, dirs, files)`. Each iteration
`path` will change to the next directory in the tree; then `dirs` and `files`
will be vectors containing the directories and files in the current `path`
directory. The directory tree can be traversed top-down or bottom-up. The
returned iterator is stateful so when accessed repeatedly each access will
resume where the last left off, like [`Iterators.Stateful`](@extref
Base.Iterators.Stateful).

See also [`readdir`](@extref Base.Filesystem.readdir),
[`Base.walkdir`](@extref Base.Filesystem.walkdir).

# Examples
```julia
for (path, ds, fs) ∈ Exts.walkdir(".")
	@info "Directories in \$path"
	for d ∈ ds
		println(path * d) # path to directories
	end
	@info "Files in \$path"
	for f ∈ fs
		println(path * f) # path to files
	end
end
```
"""
function walkdir(path::AbstractString = pwd(); topdown::Bool = true)::Channel
	_readdir = @static VERSION ≥ v"1.11" ? Base.Filesystem._readdirx : readdir
	function _walk(ch::Channel, pf::String)
		ds = String[]
		fs = String[]
		xs = @try _readdir(pf) return
		for x ∈ xs
			push!(Base.isdir(x) ? ds : fs, @static VERSION ≥ v"1.11" ? x.name : x)
		end
		topdown && push!(ch, (pf, ds, fs))
		foreach(ds) do d
			_walk(ch, stdpath(pf, d)) # LCOV_EXCL_LINE
		end
		topdown || push!(ch, (pf, ds, fs))
		nothing # LCOV_EXCL_LINE
	end
	Channel{Tuple{String, Vararg{Vector{String}, 2}}}() do chnl
		_walk(chnl, stdpath(path))
	end
end

