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

export datum
export Datum
export IntOrStr
export maybe
export Maybe
export SymOrStr
export VecOrTup
export VTuple

export @catch
export @noinfo
export @nowarn
export @try
export @trycatch
export dropmissing
export dropnothing
export ensure_vector
export getfirst
export getlast
export invsqrt
export lmap
export nanmean
export readstr
export return_type
export stdpath

using Logging: Logging
using Reexport: @reexport

@reexport begin
#! format: noindent
using Base: nonmissingtype, nonnothingtype, return_types
using Base.Threads: @spawn, @threads, nthreads
end

include("Macro.jl")
include("Type.jl")

dropmissing(itr) = collect(skipmissing(itr))
dropnothing(itr) = dropnothing(collect(itr))
dropnothing(itr::AbstractArray) = begin
	r = similar(itr, nonnothingtype(eltype(itr)), 0)
	foreach(x -> (isnothing(x) || push!(r, x)), itr)
	@static v"1.10" ≤ VERSION < v"1.11" ? (return r) : r # fix coverage on v1.10
end

ensure_vector(a::AbstractArray)  = eachslice(a, dims = ndims(a))
ensure_vector(v::AbstractVector) = v

getfirst(predicate::Function, A) = A[findfirst(predicate, A)]
getfirst(predicate::Function)    = Base.Fix1(getfirst, predicate)

getlast(predicate::Function, A) = A[findlast(predicate, A)]
getlast(predicate::Function)    = Base.Fix1(getlast, predicate)

return_type(xs...; kw...) = only(return_types(xs...; kw...)::Vector)
slash(x::AbstractString)::String = replace(x, '\\' => '/')

include("BaseExt.jl")
include("Function.jl")

# StatisticsExt
function nanmean end

end # module

