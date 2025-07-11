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

"""
	YAMLExt
"""
module YAMLExt

using Exts: lmap
using YAML: YAML, yaml

"""
	yaml(data...; delim = "") -> String

Return a YAML-formatted string of the `data`.
"""
function YAML.yaml(xs...; delim = "")::String
	join(lmap(yaml, xs), delim)
end

end # module

