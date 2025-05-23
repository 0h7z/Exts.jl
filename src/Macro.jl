# Copyright (C) 2024-2025 Heptazhou <zhou@0h7z.com>
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

for level ∈ ("info", "warn")
	local t = titlecase(level)
	local u = ["debug", "info", "warn", "error"]
	local v = "`@" .* u[begin:findlast(==(level), u)] .* "`"
	@eval begin
	#! format: noindent
	"""
		@no$($level) expr

	Suppress all lexically-enclosed uses of $($(join(v, ", "))).
	"""
	macro $(Symbol(:no, level))(expr)
	#! format: noindent
	quote
		let L = Logging.min_enabled_level(Logging.current_logger()) - 1
			try
				Logging.disable_logging(max(Logging.$(Symbol($t)), L))
				$(esc(expr))
			finally
				Logging.disable_logging(L)
			end
		end
	end
	end
	end
end

"""
	@disp expr[...] -> Nothing

Evaluate an expression and display the result.

See also [`@show`](@extref Base.@show), [`display`](@extref
Base.Multimedia.display).

# Examples
```jldoctest
julia> @disp Maybe{AbstractVecOrMat}
Union{Nothing, AbstractVecOrMat}

julia> @disp Maybe{AbstractVecOrMat}...
Nothing
AbstractVector (alias for AbstractArray{T, 1} where T)
AbstractMatrix (alias for AbstractArray{T, 2} where T)

julia> @disp "+-×÷"...
'+': ASCII/Unicode U+002B (category Sm: Symbol, math)
'-': ASCII/Unicode U+002D (category Pd: Punctuation, dash)
'×': Unicode U+00D7 (category Sm: Symbol, math)
'÷': Unicode U+00F7 (category Sm: Symbol, math)
```
"""
macro disp(ex::Expr)
	:... ≡ ex.head ?
	:(foreach(disp, ($(esc(ex)),))) :
	:(disp($(esc(ex))))
end
macro disp(ex)
	:(disp($(esc(ex))))
end

"""
	@S_str -> Symbol

Create a [`Symbol`](@extref :type:Core.Symbol) from a literal string.

# Examples
```jldoctest
julia> S"Julia"
:Julia

julia> S"\$0 expands to the name of the shell or shell script."
Symbol("\\\$0 expands to the name of the shell or shell script.")
```
"""
macro S_str(string)
	:(Symbol($string))
	# https://man.archlinux.org/man/core/bash/bash.1#Special_Parameters
end

@eval begin
	"""
		@try expr default = nothing

	Evaluate the expression with a `try/catch` construct and return the
	result. If any error (exception) occurs, return `default`.

	See also [The `try/catch` statement](@extref The-try/catch-statement),
	[`try/catch`](@extref try), [`@trycatch`](@ref), [`@catch`](@ref).
	"""
	macro $(:try)(expr, default = nothing)
		quote
			try
				$(esc(expr))
			catch
				$(esc(default))
			end
		end
	end
	"""
		@catch expr

	Evaluate the expression with a `try/catch` construct and return the
	thrown exception. If no error (exception) occurs, return `nothing`.

	See also [The `try/catch` statement](@extref The-try/catch-statement),
	[`try/catch`](@extref try), [`@trycatch`](@ref), [`@try`](@ref).
	"""
	macro $(:catch)(expr)
		quote
			try
				$(esc(expr))
				nothing
			catch e
				e
			end
		end
	end
	"""
		@trycatch expr

	Evaluate the expression with a `try/catch` construct and return either
	the result or the thrown exception, whichever available.

	See also [The `try/catch` statement](@extref The-try/catch-statement),
	[`try/catch`](@extref try), [`@try`](@ref), [`@catch`](@ref).
	"""
	macro trycatch(expr)
		quote
			try
				$(esc(expr))
			catch e
				e
			end
		end
	end
end

