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

@doc "	LDict <- LittleDict" LDict
@doc "	ODict <- OrderedDict" ODict
@doc "	OSet  <- OrderedSet" OSet
@doc "	UDict <- Dict # UnorderedDict" UDict
@doc "	USet  <- Set  # UnorderedSet" USet

