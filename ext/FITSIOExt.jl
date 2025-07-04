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
	FITSIOExt
"""
module FITSIOExt

using Base.Threads: @spawn
using Exts: SymOrStr, ensure_vector
using FITSIO: FITSIO, CFITSIO, EitherTableHDU, FITS, HDU, fitsread

@doc "	EitherTableHDU <- Union{ASCIITableHDU, TableHDU}" EitherTableHDU
@doc "	HDU  <- Union{ImageHDU, ASCIITableHDU, TableHDU}" HDU

"""
	get(f::FITS, name::AbstractString, default::Integer) -> HDU

See also [`get`](@extref Base.get).
"""
function Base.get(f::FITS, name::AbstractString, default::Integer)::HDU
	haskey(f, name) ? f[name] : f[default]
end

"""
	read(t::EitherTableHDU, Vector,
		colnames::AbstractVector{<:SymOrStr} = FITSIO.colnames(t)) -> Vector

Read a Vector of columns from the given table (of type `ASCIITableHDU` or
`TableHDU`). Each column is of type `AbstractVector` (more specifically,
either `Vector` or `AbstractSlices{S, 1} where S`).

See also [`Slices`](@extref Base.Slices).
"""
function Base.read(t::EitherTableHDU, ::Type{Vector},
	colnames::AbstractVector{<:SymOrStr} = FITSIO.colnames(t))::Vector{<:AbstractVector}
	_read(_fits_ro(t)..., Vector, colnames)
end # @doc read(::TableHDU, ::Type{Vector}, ::Vector{Symbol})

"""
	read(t::EitherTableHDU, Vector{Array},
		colnames::AbstractVector{<:SymOrStr} = FITSIO.colnames(t)) -> Vector

Read a Vector of columns from the given table (of type `ASCIITableHDU` or
`TableHDU`). Each column is of type `Array`.
"""
function Base.read(t::EitherTableHDU, ::Type{Vector{Array}},
	colnames::AbstractVector{<:SymOrStr} = FITSIO.colnames(t))::Vector{<:Array}
	_read(_fits_ro(t)..., Vector{Array}, colnames)
end # @doc read(::TableHDU, ::Type{Vector{Array}}, ::Vector{Symbol})

function _fits_ro(x::HDU)::Tuple{String, Int}
	fits = x.fitsfile
	f, n = CFITSIO.fits_file_name(fits), x.ext
	if 0 ≠ CFITSIO.fits_file_mode(fits) # 0 => read-only, 1 => read-write
		throw(ArgumentError("FITS file must be opened in read-only mode"))
	end
	f, n
end

function _read(f::String, n::Int, col::String)::Array
	fitsread(f, n, col, extendedparser = false)
end
function _read(f::String, n::Int, cols::Vector{String})::Vector{<:Array}
	fetch.(map((col -> @spawn _read(f, n, col)), cols))
end
function _read(f::String, n::Int, ::Type{Vector{Array}},
	cols::AbstractVector{<:SymOrStr})::Vector{<:Array}
	_read(f, n, String.(cols)::Vector{String})
end
function _read(f::String, n::Int, ::Type{Vector},
	cols::AbstractVector{<:SymOrStr})::Vector{<:AbstractVector}
	ensure_vector.(_read(f, n, Vector{Array}, cols))
end

# Broadcast.broadcastable(x::HDU) = Ref(x)

end # module

