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
	FITSIOExt
"""
module FITSIOExt

using Base.Threads: @spawn
using DataFrames: DataFrame
using Exts: SymOrStr, ensure_vector, lmap
using FITSIO: FITSIO, FITS, EitherTableHDU

@doc "	FITSIO.EitherTableHDU <- Union{ASCIITableHDU, TableHDU}" EitherTableHDU

"""
	read(t::FITSIO.EitherTableHDU, DataFrame,
		colnames = Tables.columnnames(t)) -> DataFrame

Read a DataFrame from the given ASCIITableHDU or TableHDU.
"""
function Base.read(t::EitherTableHDU, ::Type{DataFrame},
	colnames::AbstractVector{<:SymOrStr} = FITSIO.Tables.columnnames(t))
	fits = t.fitsfile
	f, n = FITSIO.fits_file_name(fits), t.ext
	if 0 ≠ FITSIO.fits_file_mode(fits) # 0 => read-only, 1 => read-write
		throw(ArgumentError("FITS file must be opened in read-only mode"))
	end
	cols = map(lmap(String, colnames)) do colname
		@spawn ensure_vector(FITS(f -> read(f[n], colname), f))
	end
	DataFrame(map(fetch, cols), colnames)
end # @doc read(::TableHDU, ::Type{DataFrame}, ::AbstractVector{Symbol})

end # module

