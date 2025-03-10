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
	FITSIODataFramesExt
"""
module FITSIODataFramesExt
@nospecialize

using DataFrames: DataFrame
using Exts: SymOrStr
using FITSIO: FITSIO, EitherTableHDU

"""
	read(t::FITSIO.EitherTableHDU, DataFrame,
		colnames::AbstractVector{<:SymOrStr} = FITSIO.colnames(t)) -> DataFrame

Read a DataFrame from the given table (of type `ASCIITableHDU` or
`TableHDU`).
"""
function Base.read(t::EitherTableHDU, ::Type{DataFrame},
	colnames::AbstractVector{<:SymOrStr} = FITSIO.colnames(t))::DataFrame
	DataFrame(read(t, Vector, colnames), colnames, copycols = false)
end # @doc read(::TableHDU, ::Type{DataFrame}, ::Vector{Symbol})

end # module

