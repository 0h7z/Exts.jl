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

export with_temp_env

using Exts: Exts, with_temp_env
using Pkg: Pkg

"""
	Exts.with_temp_env(f::Function)

Equivalent to `Pkg.Operations.with_temp_env(f, "@stdlib")`.
"""
function Exts.with_temp_env(f::Function)
	@noinline
	Pkg.Operations.with_temp_env(f, "@stdlib")
end

end # module

