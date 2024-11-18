# Copyright (C) 2022-2024 Heptazhou <zhou@0h7z.com>
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

using Exts
using Pkg: Pkg

cd(@__DIR__) do
	cp("Project.toml", "../docs/Project.toml", force = true)
	fs = [
		"../README.md"
		"../docs/src/api.md"
	]
	md = join(readstr.(fs), "*"^5 * "\n")
	md = replace(md, r"^#+\K\s+"m => " ")
	md = replace(md, r"^```\Kjulia$"m => "jldoctest")
	write("../docs/src/index.md", md)

	Pkg.activate("../docs")
	Pkg.update()
	include("../docs/make.jl")
end

