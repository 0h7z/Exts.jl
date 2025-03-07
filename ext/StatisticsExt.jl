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
	StatisticsExt
"""
module StatisticsExt
@nospecialize

using Exts: Exts
using StatsBase: AbstractWeights
using StatsBase: mean

"""
	nanmean(A::AbstractArray, w::AbstractWeights; dims = :)

Compute the weighted mean of array `A` with weight vector `w`, and fallback
to the unweighted mean if `w` is all zero(s) (instead of returning `NaN`). If
`dims` (of type `Int`) is provided, compute the mean along dimension `dims`.

See also [`mean(::AbstractArray)`](@extref Statistics.mean),
[`mean(::AbstractArray,
::AbstractWeights)`](https://juliastats.org/StatsBase.jl/stable/scalarstats/#Statistics.mean).
"""
function Exts.nanmean(A::AbstractArray, w::AbstractWeights; dims::Union{Colon, Int} = :)
	r = mean(A, (w); dims)
	!isnan(r) ? (r) : (x = mean(A; dims); @assert isnan(x) || all(iszero, w); x)
end # @doc nanmean

end # module

