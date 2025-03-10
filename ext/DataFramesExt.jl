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
	DataFramesExt
"""
module DataFramesExt

using DataFrames: DataFrames, AbstractDataFrame, DataFrame
using DelimitedFiles: readdlm, writedlm
using Exts: Exts, maybe

function Exts.dropmissing(x::AbstractDataFrame, xs...; kw...)
	DataFrames.dropmissing(x, xs...; kw...)
end

let doc = raw"""

Read a DataFrame from the given I/O stream or file where each line gives one
row.

If `colnames` is not provided (or, is `nothing`), the first row of data will
be read as header. If `colnames` is the symbol `:auto`, the column names will
be `x1`, `x2`, and so on. Otherwise, `colnames` must be a vector of symbols
or strings to specify column names.

If `quotes` is `true`, columns enclosed within double-quote (") characters
are allowed to contain new lines and column delimiters. Double-quote
characters within a quoted field must be escaped with another double-quote.

If `comments` is `true`, lines beginning with `comment_char` and text
following `comment_char` in any line are ignored.
"""
#! format: noindent
@doc raw"""
	read(f::AbstractString, DataFrame, colnames = nothing;
		quotes = true, comments = true, comment_char = '#') -> DataFrame
""" * doc
function Base.read(f::AbstractString, ::Type{DataFrame}, xs...; kw...)
	open(s -> read(s, DataFrame, xs...; kw...), convert(String, f)::String)
end
@doc raw"""
	read(s::IOStream, DataFrame, colnames = nothing;
		quotes = true, comments = true, comment_char = '#') -> DataFrame
""" * doc
function Base.read(s::IOStream, ::Type{DataFrame},
	colnames::maybe(Symbol, AbstractVector) = nothing, xs...; quotes::Bool = true,
	comments::Bool = true, comment_char::AbstractChar = '#', kw...)
	cols, colnames = if isnothing(colnames)
		t = readdlm(s, xs...; quotes, comments, comment_char, kw..., header = true)::NTuple{2, Matrix}
		t[1], vec(t[2])
	else
		t = readdlm(s, xs...; quotes, comments, comment_char, kw..., header = false)::Matrix
		t, colnames
	end
	DataFrame(cols, colnames)
end
end # @doc read(::IOStream, ::Type{DataFrame}, ::maybe(Symbol, AbstractVector))

let doc = raw"""

Write a DataFrame as text to the given I/O stream or file, using the given
delimiter `delim` (which defaults to tab, but can be anything printable,
typically a character or string).

Return the number of bytes written into the stream or file.
"""
#! format: noindent
@doc raw"""
	write(f::AbstractString, x::AbstractDataFrame; delim = '\t', header = true) -> Int64
""" * doc
function Base.write(f::AbstractString, x::AbstractDataFrame; kw...)
	open(s -> write(s, x; kw...), convert(String, f)::String, "w")
end
@doc raw"""
	write(s::IOStream, x::AbstractDataFrame; delim = '\t', header = true) -> Int64
""" * doc
function Base.write(s::IOStream, x::AbstractDataFrame; delim = '\t', header::Bool = true, kw...)
	pos₀ = position(s)
	writedlm(s, header ? [propertynames(x)'; Matrix(x)] : Matrix(x), delim; kw...)
	position(s) - pos₀
end
end # @doc write(::IOStream, ::AbstractDataFrame)

end # module

