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

export value

using Dates: Dates, DateTime, Date, UTC, UTM, now, value
using Exts: Exts

const EPOCH_DJD = DateTime(+1899, 12, 31, 12) #   Dublin Julian date      (IAU)
const EPOCH_J2K = DateTime(+2000, 01, 01, 12) #          Julian date 2000
const EPOCH_JUL = DateTime(-4713, 11, 24, 12) #          Julian date
const EPOCH_M2K = DateTime(+2000, 01, 01, 00) # Modified Julian date 2000 (ESA)
const EPOCH_MJD = DateTime(+1858, 11, 17, 00) # Modified Julian date      (SAO)
const EPOCH_NIX = DateTime(+1970, 01, 01, 00) #            Unix time
const EPOCH_RJD = DateTime(+1858, 11, 16, 12) #  Reduced Julian date

@inline spad(x) = isdigit((s=string(x))[begin]) ? " " * s : s
for x ∈ (:EPOCH_JUL, :EPOCH_RJD, :EPOCH_MJD, :EPOCH_DJD, :EPOCH_NIX, :EPOCH_M2K, :EPOCH_J2K)
	@eval @doc """	$($(String(x)))::DateTime = $(spad($x))""" $x
	@eval const $(Symbol(x, :_VAL))::Int64 = value($x)
	@eval export $x
end

@doc """
	datetime2mjd(dt::DateTime) -> Float64
""" Exts.datetime2mjd
@doc """
	mjd2datetime(x::Real) -> DateTime
""" Exts.mjd2datetime

Exts.datetime2mjd(dt::DateTime) = Base.Checked.checked_sub(value(dt), EPOCH_MJD_VAL) / 86400_000
Exts.mjd2datetime(x::Real)      = utm2dt(round(Int64, fma(86400e3, x, EPOCH_MJD_VAL)))

"""
	today(::Type{UTC}) -> Date

Return the date portion of `now(UTC)`.

See also [`now`](@extref Dates.now-Tuple{}), [`today`](@extref Dates.today).
"""
Dates.today(::Type{UTC}) = Date(now(UTC))

Base.typemax(::Type{DateTime}) = utm2dt(typemax(Int64))
Base.typemin(::Type{DateTime}) = utm2dt(typemin(Int64))

@inline utm2dt(x)::DateTime = DateTime(UTM(x))

__init__() = @eval Exts DatesExt = $DatesExt

end # module

