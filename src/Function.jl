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
	Exts.ext(::Colon) -> VTuple{Pair{Symbol, Maybe{Module}}}
"""
function ext(::Colon)::VTuple{Pair{Symbol, Maybe{Module}}}
	xs = (
		:Base,
		:DataFrames,
		:FITSIO,
		:Statistics,
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

@doc """
	lmap(f, iterators...)

Create a lazy mapping. This is another syntax for writing `(f(args...) for
args in zip(iterators...))`.

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

@doc raw"""
	readstr(x) -> String

Read the entirety of `x` as a string. Equivalent to `read(x, String)`.

See also [`read`](@extref Base.read), [`readchomp`](@extref Base.readchomp).
"""
readstr(x)::String = read(x, String)

"""
	invsqrt(x::T) -> float(T) where T <: Real

Return ``\\sqrt{x^{-1}}``.

See also [`sqrt`](@extref Base.sqrt-Tuple{Number}).

# Examples
```jldoctest
julia> invsqrt(4)
0.5
```
"""
function invsqrt(x::T) where T <: Real
	F::Type = float(T)
	F(big(x) |> inv |> sqrt)
end

