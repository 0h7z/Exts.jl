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

module Exts

export IntOrStr
export Maybe
export SymOrStr
export VTuple

export @catch
export @noinfo
export @nowarn
export @try
export @trycatch
export getfirst
export getlast
export invsqrt
export lmap
export nanmean
export readstr
export stdpath

using Logging: Logging
using Reexport: @reexport

@reexport begin
#! format: noindent
using Base.Threads: @spawn, @threads, nthreads
end

include("Macro.jl")
include("Type.jl")

getfirst(predicate::Function, A) = A[findfirst(predicate, A)]
getfirst(predicate::Function)    = Base.Fix1(getfirst, predicate)

getlast(predicate::Function, A) = A[findlast(predicate, A)]
getlast(predicate::Function)    = Base.Fix1(getlast, predicate)

slash(x::AbstractString)::String = replace(x, '\\' => '/')

include("BaseExt.jl")
include("Function.jl")

# StatisticsExt
function nanmean end

end # module

