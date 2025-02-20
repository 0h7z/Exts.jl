# Copyright (C) 2022-2025 Heptazhou <zhou@0h7z.com>
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

using Documenter: Documenter, DocMeta
using DocumenterInterLinks: InterLinks
using Exts
using HTTP: download

DocMeta.setdocmeta!(Exts, :DocTestSetup, quote
#! format: noindent
using Exts
end)

using DataFrames: DataFrames
using FITSIO: FITSIO
using StatsBase: StatsBase
using YAML: YAML

const cache = URL::String -> (URL, @noinfo download(URL * "objects.inv", mktempdir()))
const entry = ODict{String, String}()
const extra = Module[]
const links = InterLinks(
	"Julia" => cache("https://docs.julialang.org/en/v1/"),
)

cd(@__DIR__) do
#! format: noindent
for (k, v) ∈ Exts.ext(:)
	md = readstr("src/api.md")
	md = replace(md, "[Exts]" => "[$k]")
	md = replace(md, r"^#+\K\s+"m => " ")
	entry["$k"] = "$k.md"
	write("src/" * entry["$k"], md)
	push!(extra, v)
	@eval $k = $v
end
end

@info s"Documenter.doctest"
@noinfo Documenter.doctest(Exts, fix = true, manual = false)

@info s"Documenter.makedocs"
@noinfo Documenter.makedocs(
	format    = Documenter.HTML(),
	modules   = [Exts, extra...],
	pages     = ["Manual" => "index.md", entry...],
	pagesonly = true,
	plugins   = [links],
	sitename  = "Exts.jl",
)

@info s"Documenter.deploydocs"
@noinfo Documenter.deploydocs(
	branch    = "gh-pages",
	devbranch = "master",
	devurl    = "latest",
	forcepush = true,
	repo      = "github.com/0h7z/Exts.jl.git",
)

