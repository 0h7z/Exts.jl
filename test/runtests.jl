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

@static if ("docs") ∈ ARGS
	include("docs.jl")
	exit()
end

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
	@test fieldnames(DataType) ⊇ [:parameters]
	@test fieldnames(Union) ⊇ [:a, :b]
	@test fieldnames(UnionAll) ⊇ [:body, :var]
	@test subtypes(Type) ⊆ [Core.TypeofBottom, DataType, Union, UnionAll]

	@test Base.VecOrMat isa UnionAll
	@test Base.VecOrMat{Any} isa Union
	@test Base.VecOrMat{Any}.a isa DataType
	@test Base.VecOrMat{Any}.b isa DataType
	@test Core.BuiltinInts isa Union
	@test Core.BuiltinInts.a isa DataType
	@test Core.BuiltinInts.b isa Union
	@test Vector isa UnionAll
	@test Vector.body isa DataType
	@test Vector.body.parameters isa Core.SimpleVector
	@test Vector{Any} isa DataType
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
	# Type
	@test_throws UndefVarError datum
	@test_throws UndefVarError Datum
	@test_throws UndefVarError IntOrStr
	@test_throws UndefVarError LDict
	@test_throws UndefVarError maybe
	@test_throws UndefVarError Maybe
	@test_throws UndefVarError ODict
	@test_throws UndefVarError OSet
	@test_throws UndefVarError SymOrStr
	@test_throws UndefVarError UDict
	@test_throws UndefVarError USet
	@test_throws UndefVarError VecOrTup
	@test_throws UndefVarError VTuple
	@test_throws UndefVarError VTuple0
	@test_throws UndefVarError VTuple1
	@test_throws UndefVarError VTuple2
	@test_throws UndefVarError VTuple3
	@test_throws UndefVarError VType

	# Function
	@test_throws LoadError @eval @catch
	@test_throws LoadError @eval @noinfo
	@test_throws LoadError @eval @nowarn
	@test_throws LoadError @eval @S_str
	@test_throws LoadError @eval @try
	@test_throws LoadError @eval @trycatch
	@test_throws UndefVarError ∠
	@test_throws UndefVarError dropmissing
	@test_throws UndefVarError dropnothing
	@test_throws UndefVarError ensure_vector
	@test_throws UndefVarError flatten
	@test_throws UndefVarError getfirst
	@test_throws UndefVarError getlast
	@test_throws UndefVarError invsqrt
	@test_throws UndefVarError lmap
	@test_throws UndefVarError nanmean
	@test_throws UndefVarError notmissing
	@test_throws UndefVarError pause
	@test_throws UndefVarError polar
	@test_throws UndefVarError readstr
	@test_throws UndefVarError return_type
	@test_throws UndefVarError stdpath

	# Reexport
	@test_throws LoadError @eval @spawn
	@test_throws LoadError @eval @threads
	@test_throws UndefVarError Bottom
	@test_throws UndefVarError Fix1
	@test_throws UndefVarError Fix2
	@test_throws UndefVarError freeze
	@test_throws UndefVarError LittleDict
	@test_throws UndefVarError nonnothingtype
	@test_throws UndefVarError notnothing
	@test_throws UndefVarError nthreads
	@test_throws UndefVarError OrderedDict
	@test_throws UndefVarError OrderedSet
	@test_throws UndefVarError return_types
	@test_throws UndefVarError TypeofBottom
	@test_throws UndefVarError TypeofVararg

	@test_throws MethodError (>, <)(0)
	@test_throws MethodError (sin, cos)(0)
	@test_throws MethodError [Base.VecOrMat...]
	@test_throws MethodError [Core.BuiltinInts...]
	@test_throws MethodError [NTuple{3, Int}...]
	@test_throws MethodError [Tuple...]
	@test_throws MethodError [Union...]
	@test_throws MethodError [Union{}...]
	@test_throws MethodError collect(isodd, 1:3)
	@test_throws MethodError collect(isodd, i for i ∈ 1:3)
	@test_throws MethodError collect(Tuple{})
	@test_throws MethodError convert(Set, 1:3)
	@test_throws MethodError convert(Set{Int}, 1:3)
	@test_throws MethodError log10(11, 2)
	@test_throws MethodError ntuple(2, 1)
	@test_throws MethodError repr([:a, 1]')
	a_unionall = Union{Vector{T}, Matrix{T}, Array{T, 3}} where T
	a2_missing = Array{Missing, 2}(undef, Tuple(rand(0:9, 2)))
	a3_nothing = Array{Nothing, 3}(undef, Tuple(rand(0:9, 3)))
	using Exts

	@test (>, <)(0) === (>(0), <(0))
	@test (>, <)(0) isa NTuple{2, Fix2{<:Function, Int}}
	@test (sin, cos)(0) === sincos(0) === (0.0, 1.0)
	@test [:_ -1] == [:_, -1]'
	@test [:p :q] == [:p, :q]'
	@test ['1' '2'] == ['1', '2']'
	@test ["x" "y"] == ["x", "y"]'
	@test [a_unionall::UnionAll...] == UnionAll[Vector, Matrix, Array{T, 3} where T]
	@test [AbstractMatrix...] == [Vector...] == []
	@test [AbstractMatrix{UInt8}...] == [UInt8, 2]
	@test [AbstractVecOrMat...] == [AbstractVector, AbstractMatrix]
	@test [Core.BuiltinInts...] ⊋ [Bool, Int8, Int16, Int32, Int64, Int128]
	@test [NTuple{3, Int}...] == fill(Int, 3)
	@test [Tuple...] == [Vararg{Any}]
	@test [Tuple{}...] == [NTuple...] == []
	@test [Tuple{Float16, Float32, Float64}...] == [Float16, Float32, Float64]
	@test [Union{}...] == [Union...] == []
	@test [Vector{Union{Unsigned, Signed}}...] == [Union{Unsigned, Signed}, 1]
	@test [VTuple1{Function}...] == [Function, Vararg{Function}]
	@test all(@. only(ntuple(1, Val(0:9))) === Val(0:9))
	@test allequal(length.([NTuple{0, Type}, collect(Tuple{}), Tuple{}]))
	@test allequal(length.([NTuple{1, Type}, VTuple0{Type}, VTuple{Type}, Tuple{Type}]))
	@test allequal(length.([NTuple{2, Type}, VTuple1{Type}]))
	@test allequal(length.([NTuple{3, Type}, VTuple2{Type}]))
	@test allequal(length.([NTuple{4, Type}, VTuple3{Type}]))
	@test cd(() -> stdpath("../test"), @__DIR__) === "./"
	@test chomp(readstr(@__FILE__)) === readchomp(@__FILE__)
	@test collect(isodd, i for i ∈ 1:3) == collect(isodd, 1:3) == [1, 3]
	@test convert(Set{Int}, 1:3) == convert(Set, 1:3) == Set(1:3)
	@test copy.(ensure_vector(a2_missing)) isa Vector{Vector{Missing}}
	@test copy.(ensure_vector(a3_nothing)) isa Vector{Matrix{Nothing}}
	@test Datum{Missing} == datum(Missing) == datum() == Missing
	@test Datum{Nothing} == datum(Nothing) == datum(Nothing, Nothing)
	@test dropmissing(x for x ∈ a2_missing) == dropmissing(a2_missing) == []
	@test dropnothing(x for x ∈ a3_nothing) == dropnothing(a3_nothing) == []
	@test ensure_vector(a3_nothing) isa AbstractVector{<:AbstractMatrix{Nothing}}
	@test flatten(rand(UInt8, 3, 3, 3)::Array{UInt8, 3}) isa Vector{UInt8}
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
	@test notmissing(nothing) === nothing
	@test notnothing(missing) === missing
	@test ntuple(0, 0x1) === ()
	@test ntuple(1, 0x1) === (0x1,)
	@test ntuple(2, 0x1) === (0x1, 0x1)
	@test ntuple(2, Int) === (Int, Int)
	@test ntuple(2, Int32(1)) === Int32.((1, 1))
	@test ntuple(2, Int64(1)) === Int64.((1, 1))
	@test ntuple(2, Val(001)) === Val.((001, 001))
	@test ntuple(2, Val(0x1)) === Val.((0x1, 0x1))
	@test polar(1, -90) === ∠(270) == -(1im)
	@test polar(1, +90) === ∠(090) == +(1im)
	@test polar(1, 180) === ∠(180) == -(1.0)
	@test polar(1, 360) === ∠(000) == +(1.0)
	@test polar(1, rad2deg(1)) === ∠(rad2deg(1)) === Exts.cis(1)
	@test return_type(invsqrt, ntuple(1, Any)) == AbstractFloat
	@test return_type(log10, ntuple(2, Any)) == NTuple{2, AbstractFloat}
	@test stdpath("...") == "..."
	@test stdpath("..") == "../"
	@test stdpath(".") == "./"
	@test stdpath("") == ""
	@test Tuple === Tuple{Vararg{Any}} === VTuple{Any}
	@test_throws ArgumentError notmissing(missing)
	@test_throws ArgumentError notnothing(nothing)

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
	@test S":" === :(:)
	end

	fi, i = mktemp()
	fo, o = mktemp()
	redirect_stdio(stdin = i, stdout = o) do
		write(stdin, '\n'), seekstart(stdin)
		pause()
	end
	close.((i, o))
	@test readstr(fo) ≡ "Press any key to continue . . . \n"
end

@testset "DataFramesExt" begin
	using DataFrames: DataFrame
	df  = DataFrame(rand(Int16, (8, 2)), [:x, :y])
	tmp = tempname(mktempdir())
	using CSV: CSV
	@test 36 ≤ write(tmp, df) == filesize(tmp)
	@test df == read(tmp, DataFrame)
	@test df == read(tmp, DataFrame, [:x, :y], skipstart = 1)
	@test df == CSV.read(tmp, DataFrame)
	@test dropmissing(DataFrame(x = [missing, 1])) == DataFrame(x = [1])
end

@testset "FITSIOExt" begin
	using FITSIO: FITSIO, CFITSIO, FITS
	@test ccall((:fits_is_reentrant, CFITSIO.libcfitsio), Bool, ())
	# https://heasarc.gsfc.nasa.gov/fitsio/c/c_user/node15.html

	using HTTP: HTTP
	tmp = HTTP.download(
		"https://data.sdss.org/sas/dr18/spectro/sdss/redux/" *
		"v5_13_2/spectra/lite/3650/spec-3650-55244-0001.fits",
		mktempdir(), update_period = Inf,
	)
	FITS(f -> @test_throws(ArgumentError,
			read(f["SPALL"], DataFrame)), tmp, "r+")
	FITS(f -> @test_nowarn(
			read(f["SPALL"], DataFrame)), tmp, "r")
end

@testset "StatisticsExt" begin
	using StatsBase: mean, weights
	@test mean(1:20, weights(zeros(20))) |> isnan
	@test mean(1:20) === nanmean(1:20, weights(zeros(20)))
end

@test all(nameof.(last.(Exts.ext(:))) .== first.(Exts.ext(:)))
@static parse(Bool, get(ENV, "CI", "0")) || include("docs.jl")

