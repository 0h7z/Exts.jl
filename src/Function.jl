# Copyright (C) 2023-2024 Heptazhou <zhou@0h7z.com>
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
cis(theta::Real)::Complex{<:AbstractFloat} = cispi(theta / π)

"""
	Exts.ext(::Colon) -> VTuple{Pair{Symbol, Maybe{Module}}}
"""
function ext(::Colon)::VTuple{Pair{Symbol, Maybe{Module}}}
	xs = (
		:Base,
		:DataFrames,
		:FITSIO,
		:Statistics,
		:YAML,
	)
	map(x -> Symbol(x, :Ext) => ext(x), xs)
end
"""
	Exts.ext(x::Symbol) -> Maybe{Module}
"""
function ext(x::Symbol)::Maybe{Module}
	x ≡ :Base ? BaseExt :
	Base.get_extension(Exts, Symbol(x, :Ext))
end

"""
	invsqrt(x::T) -> AbstractFloat where T <: Real

Return ``\\sqrt{x^{-1}}``.

See also [`sqrt`](@extref Base.sqrt-Tuple{Number}).

# Examples
```jldoctest
julia> invsqrt(4)
0.5
```
"""
function invsqrt(x::T)::AbstractFloat where T <: Real
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
	cispi(azimuth / 180) * radius
end
"""
	∠(azimuth::Real) -> Complex{<:AbstractFloat}

Return ``1∠θ``, where ``θ`` is in degrees. Equivalent to `polar(1, azimuth)`.

See also [`polar`](@ref), [`Exts.cis`](@ref).
"""
function ∠(azimuth::Real)::Complex{<:AbstractFloat}
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
julia> stdpath("/home/myuser/../example.jl")
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

