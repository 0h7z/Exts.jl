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

@eval begin
	"""
		@try expr default = nothing

	Evaluate the expression with a `try/catch` construct and return the
	result. If any error (exception) occurs, return `default`.

	See also [The-try/catch-statement](@extref), [`try/catch`](@extref try),
	[`@trycatch`](@ref), [`@catch`](@ref).
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

	See also [The-try/catch-statement](@extref), [`try/catch`](@extref try),
	[`@trycatch`](@ref), [`@try`](@ref).
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

	See also [The-try/catch-statement](@extref), [`try/catch`](@extref try),
	[`@try`](@ref), [`@catch`](@ref).
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

