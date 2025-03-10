# Copyright (C) 2025 Heptazhou <zhou@0h7z.com>
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
	PkgExt
"""
module PkgExt
@nospecialize

export with_temp_env

using Base: PkgId, UUID, require

# Pkg = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
const Pkg() = require(PkgId(
	UUID(0x44cfe95a_1eb2_52ea_b672_e2afdf69b78f),
	"Pkg",
))

"""
	Exts.with_temp_env(f::Function)

Equivalent to `Pkg.Operations.with_temp_env(f, "@stdlib")`.
"""
function with_temp_env(f::Function)
	@noinline
	@invokelatest Pkg().Operations.with_temp_env(f, "@stdlib")
end

end

