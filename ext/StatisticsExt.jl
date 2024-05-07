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

module StatisticsExt

using Exts: Exts
using StatsBase: AbstractWeights
using StatsBase: mean

function Exts.nanmean(A::AbstractArray, w::AbstractWeights; dims = :)
	r = mean(A, (w); dims)
	!isnan(r) ? (r) : (@assert all(iszero, w); mean(A; dims))
end

end # module

