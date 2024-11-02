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
	v = Type[Real]
	map(_ -> unique!(append!(v, mapreduce(subtypes, vcat, v))), 1:3)

	@test 24 <= length(v)
	@test all(@. float(v) <: AbstractFloat)
end

@testset "Base" begin
	@static if !Sys.iswindows()
	#! format: noindent
	@test Bool(0) == Base.isdir("")
	@test Bool(1) == Base.isdir(".")
	@test Bool(1) == Base.isdir("..")
	@test Bool(0) == Base.isdir("...")
	@test Bool(0) == Base.isdir("/...")
	@test Bool(0) == Base.isdir("/.../")
	else
	#! format: noindent
	@test Bool(0) == Base.isdir("")
	@test Bool(1) == Base.isdir(".")
	@test Bool(1) == Base.isdir("..")
	@test Bool(1) == Base.isdir("...") # why?
	@test Bool(1) == Base.isdir("/...") # why?
	@test Bool(1) == Base.isdir("/.../") # why?
	end
	@test Bool(1) == Base.isdirpath("") # why?
	@test Bool(1) == Base.isdirpath(".")
	@test Bool(1) == Base.isdirpath("..")
	@test Bool(0) == Base.isdirpath("...")
	@test Bool(0) == Base.isdirpath("/...")
	@test Bool(1) == Base.isdirpath("/.../")

	@test joinpath("") == ""
	@test normpath("") == "." # why?
	@test_throws Base.IOError realpath("")
end

@testset "BaseExt" begin
	@test_throws MethodError collect(isodd, 1:3)
	@test_throws MethodError collect(isodd, i for i ∈ 1:3)
	@test_throws MethodError convert(Set, 1:3)
	@test_throws MethodError convert(Set{Int}, 1:3)
	@test_throws MethodError log10(11, 2)
	@test_throws MethodError ntuple(2, 1)
	@test_throws MethodError repr([:a, 1]')
	@test_throws UndefVarError datum
	@test_throws UndefVarError Datum
	@test_throws UndefVarError ensure_vector
	@test_throws UndefVarError getfirst
	@test_throws UndefVarError getlast
	@test_throws UndefVarError invsqrt
	@test_throws UndefVarError maybe
	@test_throws UndefVarError Maybe
	@test_throws UndefVarError readstr
	@test_throws UndefVarError stdpath
	a2_missing = Array{Missing, 2}(undef, Tuple(rand(0:9, 2)))
	a3_nothing = Array{Nothing, 3}(undef, Tuple(rand(0:9, 3)))
	using Exts

	@test [:_ -1] == [:_, -1]'
	@test [:p :q] == [:p, :q]'
	@test ['1' '2'] == ['1', '2']'
	@test ["x" "y"] == ["x", "y"]'
	@test all(@. only(ntuple(1, Val(0:9))) === Val(0:9))
	@test cd(() -> stdpath("../test"), @__DIR__) == "./"
	@test chomp(readstr(@__FILE__)) == readchomp(@__FILE__)
	@test collect(isodd, i for i ∈ 1:3) == collect(isodd, 1:3) == [1, 3]
	@test convert(Set{Int}, 1:3) == convert(Set, 1:3) == Set(1:3)
	@test copy.(ensure_vector(a2_missing)) isa Vector{Vector{Missing}}
	@test copy.(ensure_vector(a3_nothing)) isa Vector{Matrix{Nothing}}
	@test Datum{Missing} == datum(Missing) == datum() == Missing
	@test Datum{Nothing} == datum(Nothing) == datum(Nothing, Nothing)
	@test dropmissing(x for x ∈ a2_missing) == dropmissing(a2_missing) == []
	@test dropnothing(x for x ∈ a3_nothing) == dropnothing(a3_nothing) == []
	@test ensure_vector(a3_nothing) isa AbstractVector{<:AbstractMatrix{Nothing}}
	@test getfirst(iseven, 1:9) == getfirst(iseven)(1:9) == 2
	@test getlast(iseven, 1:9) == getlast(iseven)(1:9) == 8
	@test invsqrt(2^-2) == 2
	@test log10(11, 2) isa NTuple{2, Float64}
	@test Maybe{Missing} == maybe(Missing) == maybe(Missing, Missing)
	@test Maybe{Nothing} == maybe(Nothing) == maybe() == Nothing
	@test nonmissingtype(Datum{Missing}) == Union{}
	@test nonmissingtype(Datum{Nothing}) == Nothing
	@test nonnothingtype(Maybe{Missing}) == Missing
	@test nonnothingtype(Maybe{Nothing}) == Union{}
	@test ntuple(0, 0x1) === ()
	@test ntuple(1, 0x1) === (0x1,)
	@test ntuple(2, 0x1) === (0x1, 0x1)
	@test ntuple(2, Int) === (Int, Int)
	@test ntuple(2, Int32(1)) === Int32.((1, 1))
	@test ntuple(2, Int64(1)) === Int64.((1, 1))
	@test ntuple(2, Val(001)) === Val.((001, 001))
	@test ntuple(2, Val(0x1)) === Val.((0x1, 0x1))
	@test return_type(invsqrt, ntuple(1, Any)) == AbstractFloat
	@test return_type(log10, ntuple(2, Any)) == NTuple{2, AbstractFloat}
	@test stdpath("...") == "..."
	@test stdpath("..") == "../"
	@test stdpath(".") == "./"
	@test stdpath("") == ""

	@test Bool(0) == Exts.isdir("")
	@test Bool(1) == Exts.isdir(".")
	@test Bool(1) == Exts.isdir("..")
	@test Bool(0) == Exts.isdir("...")
	@test Bool(0) == Exts.isdir("/...")
	@test Bool(0) == Exts.isdir("/.../")

	@test Bool(0) == Exts.isdirpath("")
	@test Bool(1) == Exts.isdirpath(".")
	@test Bool(1) == Exts.isdirpath("..")
	@test Bool(0) == Exts.isdirpath("...")
	@test Bool(0) == Exts.isdirpath("/...")
	@test Bool(1) == Exts.isdirpath("/.../")

	@eval begin
	#! format: noindent
	@test @try error() true
	@test @trycatch true
	@test ErrorException("") == @catch error()
	@test ErrorException("") == @trycatch error()
	@test isnothing(@catch true)
	@test isnothing(@try error())
	end
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
	@test dropmissing(DataFrame(x = [1, missing])) == DataFrame(x = [1])
end

@testset "FITSIOExt" begin
	using FITSIO: FITSIO, CFITSIO, FITS
	@test ccall((:fits_is_reentrant, CFITSIO.libcfitsio), Bool, ())
	# https://heasarc.gsfc.nasa.gov/fitsio/c/c_user/node15.html

	using HTTP: HTTP
	tmp = HTTP.download(
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

