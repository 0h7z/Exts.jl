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
	PythonCallExt
"""
module PythonCallExt

using Exts: Exts
using PythonCall: Py, pyconvert

# LCOV_EXCL_START
Exts.Jl(x::Any) = x
Exts.Jl(x::Py)  = pyconvert(Any, x)
# LCOV_EXCL_STOP

end

