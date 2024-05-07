# Copyright (C) 2018-2024 Heptazhou <zhou@0h7z.com>
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

module BaseExt

function Base.adjoint(m::T)::AbstractMatrix{Any} where T <: AbstractVecOrMat{Any}
	permutedims(m)
end
function Base.adjoint(m::T)::AbstractMatrix{<:Symbol} where T <: AbstractVecOrMat{<:Symbol}
	permutedims(m)
end
function Base.adjoint(m::T)::AbstractMatrix{<:AbstractChar} where T <: AbstractVecOrMat{<:AbstractChar}
	permutedims(m)
end
function Base.adjoint(m::T)::AbstractMatrix{<:AbstractString} where T <: AbstractVecOrMat{<:AbstractString}
	permutedims(m)
end

function Base.log10(x::T, σ::T) where T <: Real
	# https://physics.stackexchange.com/q/95254
	log10(x), σ / log(10)x
end

end # module

