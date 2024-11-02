# Copyright (C) 2018-2024 Heptazhou <zhou@0h7z.com>
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
	BaseExt
"""
module BaseExt

function Base.adjoint(m::T) where T <: AbstractVecOrMat{Any}
	permutedims(m)::AbstractMatrix{Any}
end
function Base.adjoint(m::T) where T <: AbstractVecOrMat{<:Symbol}
	permutedims(m)::AbstractMatrix{<:Symbol}
end
function Base.adjoint(m::T) where T <: AbstractVecOrMat{<:AbstractChar}
	permutedims(m)::AbstractMatrix{<:AbstractChar}
end
function Base.adjoint(m::T) where T <: AbstractVecOrMat{<:AbstractString}
	permutedims(m)::AbstractMatrix{<:AbstractString}
end

function Base.collect(f::Function, collection)
	filter(f, collect(collection))
end

function Base.convert(::Type{S}, v::AbstractVector) where S <: AbstractSet
	S(eltype(S)[v;])
end
function Base.convert(::Type{S}, v::AbstractVector) where S <: AbstractSet{T} where T
	S(T[v;])
end

"""
	log10(x::T, σ::T) -> NTuple{2, AbstractFloat} where T <: Real

Compute the logarithm of `x ± σ` to base 10.
"""
function Base.log10(x::T, σ::T)::NTuple{2, AbstractFloat} where T <: Real
	F::Type = float(T)
	log10(x)::F, F(σ / log(10)x)::F
	# https://physics.stackexchange.com/q/95254
end # @doc log10(::T, ::T) where T <: Real

for T ∈ (Any, Int, Integer, Val, typeof.(Val.(0:3))...)
	@eval begin
		function Base.ntuple(n::Int, x::$T)
			ntuple(Returns(x), n)::NTuple{N, T} where {N, T <: $T}
		end
	end
end

end # module

