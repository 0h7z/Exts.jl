# Copyright (C) 2023-2024 Heptazhou <zhou@0h7z.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

module FITSIOExt

using Base.Threads: @spawn
using DataFrames: DataFrame
using FITSIO: FITSIO, FITS, EitherTableHDU

const StrOrSym = Union{AbstractString, Symbol}

const ensure_vector(a::AbstractArray)  = eachslice(a, dims = ndims(a))
const ensure_vector(v::AbstractVector) = v

function Base.read(t::EitherTableHDU, ::Type{DataFrame},
	colnames::AbstractVector{<:StrOrSym} = FITSIO.Tables.columnnames(t))
	fits = t.fitsfile
	f, n = FITSIO.fits_file_name(fits), t.ext
	if 0 ≠ FITSIO.fits_file_mode(fits) # 0 => read-only, 1 => read-write
		throw(ArgumentError("FITS file must be opened in read-only mode"))
	end
	cols = map(map(String, colnames)) do colname
		@spawn ensure_vector(FITS(f -> read(f[n], colname), f))
	end
	DataFrame(map(fetch, cols), colnames)
end

# https://github.com/JuliaAstro/FITSIO.jl/pull/193
@static if !hasmethod(FITSIO.fits_tform_char, (Type{UInt64},))
	FITSIO.fits_tform_char(::Type{UInt64}) = 'W'
end
@static if !haskey(FITSIO.CFITSIO_COLTYPE, 080)
	function __init__()
		FITSIO.CFITSIO_COLTYPE[080] = UInt64
		nothing
	end
end

end # module

