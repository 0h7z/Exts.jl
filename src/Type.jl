# Copyright (C) 2024 Heptazhou <zhou@0h7z.com>
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

for N ∈ 0:3
	VTupleN = Symbol(:VTuple, N)
	@eval const $VTupleN{T} = Tuple{NTuple{$N, T}..., Vararg{T}}
	@eval export $VTupleN
end

const IntOrStr = Union{AbstractString, Integer}
const SymOrStr = Union{AbstractString, Symbol}
const VecOrTup = Union{AbstractVector, Tuple}
const VType    = Union{Type, TypeofVararg}

const Datum{T} = Union{T, Missing}
const Maybe{T} = Union{T, Nothing}
const VTuple{T} = VTuple0{T}

const datum(T::Type...) = Datum{Union{T...}}
const maybe(T::Type...) = Maybe{Union{T...}}

@doc "	IntOrStr <- Union{AbstractString, Integer}" IntOrStr
@doc "	SymOrStr <- Union{AbstractString, Symbol}" SymOrStr
@doc "	VecOrTup <- Union{AbstractVector, Tuple}" VecOrTup
@doc "	VType    <- Union{Type, TypeofVararg}" VType

@doc """
	Datum{T} <- Union{T, Missing}
	datum(T::Type...) -> Datum{Union{T...}}
""" Datum, datum
@doc """
	Maybe{T} <- Union{T, Nothing}
	maybe(T::Type...) -> Maybe{Union{T...}}
""" Maybe, maybe
@doc """
	VTuple{T}  <- VTuple0{T}
	VTuple0{T} <- Tuple{Vararg{T}}          # 0 or more
	VTuple1{T} <- Tuple{T, Vararg{T}}       # 1 or more
	VTuple2{T} <- Tuple{T, T, Vararg{T}}    # 2 or more
	VTuple3{T} <- Tuple{T, T, T, Vararg{T}} # 3 or more
""" VTuple

const LDict = LittleDict
const ODict = OrderedDict
const OSet  = OrderedSet
const UDict = Dict
const USet  = Set

@doc """
	LDict <- LittleDict

An ordered dictionary type for small numbers of keys. Rather than using
`hash` or some other sophisticated measure to store the vals in a clever
arrangement, it just keeps everything in a pair of lists.

While theoretically this has expected time complexity ``O(n)`` (vs the
hash-based `OrderedDict`/`Dict`'s expected time complexity ``O(1)``, and the
search-tree-based `SortedDict`'s expected time complexity ``O(\\log n)``), in
practice it is really fast, because it is cache & SIMD friendly.

It is reasonable to expect it to outperform an `OrderedDict`, with up to
around 30 elements in general; or with up to around 50 elements if using a
`LittleDict` backed by `Tuple`s. However, this depends on exactly how long
`isequal` and `hash` take, as well as on how many hash collisions occur etc.
""" LDict
# https://github.com/JuliaCollections/OrderedCollections.jl/blob/master/src/little_dict.jl
@doc """
	ODict <- OrderedDict

`OrderedDict`s are simply dictionaries whose entries have a particular order.
The order refers to insertion order, which allows deterministic iteration
over the dictionary.
""" ODict
# https://github.com/JuliaCollections/OrderedCollections.jl/blob/master/src/ordered_dict.jl
@doc """
	OSet  <- OrderedSet

`OrderedSet`s are simply sets whose entries have a particular order. The
order refers to insertion order, which allows deterministic iteration over
the set.
""" OSet
# https://github.com/JuliaCollections/OrderedCollections.jl/blob/master/src/ordered_set.jl

@doc """
	UDict <- Dict # UnorderedDict

See [`Base.Dict`](@extref).
""" UDict
@doc """
	USet  <- Set  # UnorderedSet

See [`Base.Set`](@extref).
""" USet

