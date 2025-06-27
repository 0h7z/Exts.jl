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
	DatesExt
"""
module DatesExt

using Dates: Dates, DateTime, Date, UTC, UTM, now, value
using Exts: Exts

const EPOCH_DJD = DateTime(+1899, 12, 31, 12) # Dublin JD
const EPOCH_J2K = DateTime(+2000, 01, 01, 12) # JD 2000
const EPOCH_JUL = DateTime(-4713, 11, 24, 12) # JD
const EPOCH_M2K = DateTime(+2000, 01, 01, 00) # Modified JD 2000
const EPOCH_MJD = DateTime(+1858, 11, 17, 00) # Modified JD
const EPOCH_NIX = DateTime(+1970, 01, 01, 00) # Unix
const EPOCH_RJD = DateTime(+1858, 11, 16, 12) # Reduced JD

@inline ppad(x) = isdigit((s=string(x))[begin]) ? "+" * s : s
for x ∈ (:EPOCH_JUL, :EPOCH_RJD, :EPOCH_MJD, :EPOCH_DJD, :EPOCH_NIX, :EPOCH_M2K, :EPOCH_J2K)
	@eval export $x
	@eval let s = $(string(x)), t = typeof($x), u = ppad($x), v = ppad(value($x))
		@doc """\t$s::$t = $u = $v""" $x
	end
end

"""
	today(::Type{UTC}) -> Date

Return the date portion of `now(UTC)`.

See also [`now`](@extref Dates.now-Tuple{}), [`today`](@extref Dates.today).
"""
Dates.today(::Type{UTC}) = Date(now(UTC))

Exts.datetime2mjd(dt::DateTime) = (value(dt) - value(EPOCH_MJD)::Int64) / 86400_000Float64
Exts.mjd2datetime(x::Real)      = DateTime(UTM(value(EPOCH_MJD)::Int64 + round(Int64, (86400_000BigInt)x)))

__init__() = @eval Exts DatesExt = $DatesExt

end # module

