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

module Exts
@nospecialize

export datum
export Datum
export IntOrStr
export LDict
export maybe
export Maybe
export ODict
export OSet
export SymOrStr
export UDict
export USet
export VecOrTup
export VTuple
export VType

export @catch
export @disp
export @noinfo
export @nowarn
export @S_str
export @try
export @trycatch
export ∠
export dropmissing
export dropnothing
export ensure_vector
export flatten
export freeze
export getall
export getfirst
export getlast
export invsqrt
export lmap
export nanmean
export notmissing
export pause
export polar
export readstr
export return_type
export stdpath

using Logging: Logging
using OrderedCollections: OrderedCollections
using Reexport: @reexport

@reexport begin
#! format: noindent
using Base: Bottom, Fix1, Fix2
using Base: nonnothingtype, notnothing, return_types
using Base.Threads: @spawn, @threads, nthreads
using Core: TypeofBottom, TypeofVararg
using OrderedCollections: FrozenLittleDict, UnfrozenLittleDict
using OrderedCollections: LittleDict, OrderedDict, OrderedSet
end

include("BaseExt.jl")
include("Macro.jl")
include("PkgExt.jl")
include("Type.jl")

(fs::VTuple1{Function})(xs...; kw...) = ((f(xs...; kw...) for f ∈ fs)...,)

disp(io::IO, x)::Nothing = (show(io, MIME("text/plain"), x); println(io))
disp(x)::Nothing         = (disp(stdout, x))

dropmissing(itr) = collect(skipmissing(itr))
dropnothing(itr) = dropnothing(collect(itr))
dropnothing(itr::AbstractArray) = begin
	r = similar(itr, nonnothingtype(eltype(itr)), 0)
	foreach(x -> (isnothing(x) || push!(r, x)), itr)
	@static v"1.10" ≤ VERSION < v"1.11" ? (return r) : r # fix coverage on v1.10
end

ensure_vector(a::AbstractArray)::AbstractVector  = eachslice(a, dims = ndims(a))
ensure_vector(v::AbstractVector)::AbstractVector = v

flatten(itr) = collect(Iterators.flatten(itr))

getall(predicate::Function, A) = A[findall(predicate, A)]
getall(predicate::Function) = Fix1(getall, predicate)

getfirst(predicate::Function, A) = A[findfirst(predicate, A)]
getfirst(predicate::Function) = Fix1(getfirst, predicate)

getlast(predicate::Function, A) = A[findlast(predicate, A)]
getlast(predicate::Function) = Fix1(getlast, predicate)

return_type(xs...; kw...) = only(unique!(return_types(xs...; kw...)::Vector))

slash(x::AbstractString)::String = replace(x, '\\' => '/')

function pause(msg::Maybe{AbstractString} = nothing; ante::Int = 0, post::Int = 0)::Nothing
	print(stdout, '\n'^ante)
	pause(stdin, stdout, msg)
	print(stdout, '\n'^post)
end
function pause(i::IO, o::IO, msg::Maybe{AbstractString} = nothing)::Nothing
	print(o, @something msg raw"Press any key to continue . . . ")
	ccall(:jl_tty_set_mode, Cint, (Ptr{Cvoid}, Cint), i.handle, 1)
	read(i, Char)
	ccall(:jl_tty_set_mode, Cint, (Ptr{Cvoid}, Cint), i.handle, 0)
	print(o, '\n')
end

include("Function.jl")

# PkgExt
using .PkgExt

# PythonCallExt
function Jl end

# StatisticsExt
function nanmean end

end # module

