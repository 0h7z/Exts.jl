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

using InteractiveUtils: subtypes
using Test

@testset "Pkg" begin
	using Pkg: Pkg, PlatformEngines
	@test getfield.(Pkg.Registry.reachable_registries(), :name) ⊇ ["General", "0hjl"]
	@test any(startswith("7-Zip "), readlines(PlatformEngines.exe7z()))
	# https://github.com/ip7z/7zip/blob/main/CPP/7zip/UI/Console/Main.cpp
	# https://github.com/mcmilk/7-Zip/blob/master/CPP/7zip/UI/Console/Main.cpp
	# https://github.com/p7zip-project/p7zip/blob/master/CPP/7zip/UI/Console/Main.cpp

	@test PlatformEngines.p7zip_jll.is_available()
	@info PlatformEngines.p7zip_jll.p7zip_path
	@info PlatformEngines.find7z()
end

@testset "Core" begin
	local v = Type[Real]
	map(_ -> unique!(append!(v, mapreduce(subtypes, vcat, v))), 1:3)

	@test 24 <= length(v)
	@test all(@. float(v) <: AbstractFloat)
end

@testset "BaseExt" begin
	@test_throws MethodError convert(Set, 1:3)
	@test_throws MethodError convert(Set{Int}, 1:3)
	@test_throws MethodError log10(11, 2)
	@test_throws MethodError repr([:a, 1]')
	@test_throws UndefVarError getfirst
	@test_throws UndefVarError getlast
	@test_throws UndefVarError invsqrt
	@test_throws UndefVarError Maybe
	@test_throws UndefVarError readstr
	using Exts

	@test [:_ -1] == [:_, -1]'
	@test [:p :q] == [:p, :q]'
	@test ['1' '2'] == ['1', '2']'
	@test ["x" "y"] == ["x", "y"]'
	@test chomp(readstr(@__FILE__)) == readchomp(@__FILE__)
	@test convert(Set{Int}, 1:3) == convert(Set, 1:3) == Set(1:3)
	@test getfirst(iseven, 1:9) == getfirst(iseven)(1:9) == 2
	@test getlast(iseven, 1:9) == getlast(iseven)(1:9) == 8
	@test invsqrt(2^-2) == 2
	@test Maybe{Int} == Maybe(Int) == Maybe(Int, Int)
	@test Maybe{Nothing} == Maybe(Nothing) == Nothing
	@test_nowarn log10(11, 2)
end

@testset "DataFramesExt" begin
	using DataFrames: DataFrame
	df  = DataFrame(rand(Int16, (8, 2)), [:x, :y])
	tmp = tempname()
	using CSV: CSV
	@test 36 ≤ write(tmp, df) == filesize(tmp)
	@test df == read(tmp, DataFrame)
	@test df == read(tmp, DataFrame, [:x, :y], skipstart = 1)
	@test df == CSV.read(tmp, DataFrame)
end

@testset "FITSIOExt" begin
	using FITSIO: FITSIO, CFITSIO, FITS
	@test ccall((:fits_is_reentrant, CFITSIO.libcfitsio), Bool, ())
	# https://heasarc.gsfc.nasa.gov/fitsio/c/c_user/node15.html

	local A_Nothing = Array{Nothing, 3}(undef, Tuple(rand(0:9, 3)))
	@test Exts.ext(:FITSIO).ensure_vector(A_Nothing) isa
		  AbstractVector{<:AbstractMatrix{Nothing}}

	using HTTP: HTTP
	local tmp = @nowarn HTTP.download(
		"https://data.sdss.org/sas/dr18/spectro/sdss/redux/" *
		"v5_13_2/spectra/lite/3650/spec-3650-55244-0001.fits",
		update_period = Inf,
	)
	FITS(f -> @test_throws(ArgumentError,
			read(f["SPALL"], DataFrame)), tmp, "r+")
	FITS(f -> @test_nowarn(
			read(f["SPALL"], DataFrame)), tmp, "r")
	rm(tmp, force = true)
end

@testset "StatisticsExt" begin
	using StatsBase: mean, weights
	@test mean(1:20, weights(zeros(20))) |> isnan
	@test mean(1:20) === nanmean(1:20, weights(zeros(20)))
end

@test all(nameof.(last.(Exts.ext(:))) .== first.(Exts.ext(:)))
@static parse(Bool, get(ENV, "CI", "0")) || cd(@__DIR__) do
	cp("./Project.toml", "../docs/Project.toml", force = true)
	fs = [
		"../README.md"
		"../docs/src/api.md"
	]
	md = join(readstr.(fs), "*"^5 * "\n")
	md = replace(md, r"^#+\K\s+"m => " ")
	write("../docs/src/index.md", md)

	include("../docs/make.jl")
end

