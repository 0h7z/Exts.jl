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

@static if ("docs") ∈ ARGS
	include("docs.jl")
	exit()
end

using InteractiveUtils: subtypes
using Test

@testset "Pkg" begin
	using Pkg: PlatformEngines, Registry
	@test getfield.(Registry.reachable_registries(), :name) ⊇ ["General", "0hjl"]
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
	@test fieldnames(Expr) ⊇ [:head, :args]
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
	using Base: IOError, unwrap_unionall
	ms = methods(ntuple, (Int, Any), (Base))
	ts = [unwrap_unionall(m.sig) for m ∈ ms]
	v1 = ["$(t.parameters[(3)])" for t ∈ ts]
	v2 = ["$Int", "Integer", ("Val{$N}" for N ∈ [0:3; :N])...]
	@test v1 ⊆ v2

	project  = ["Julia", ""] .* "Project"
	manifest = ["Julia", ""] .* "Manifest"
	@static if VERSION ≥ v"1.10.8"
		manifest = manifest .* ["-v1.$(VERSION.minor)" ""]
	end
	@test Base.project_names ≡ (project .* ".toml"...,)
	@test Base.manifest_names ≡ (manifest .* ".toml"...,)

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
	@test_throws IOError realpath("")
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
	@test_throws LoadError @eval @disp
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
	@test_throws UndefVarError freeze
	@test_throws UndefVarError getall
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
	@test_throws UndefVarError FrozenLittleDict
	@test_throws UndefVarError LittleDict
	@test_throws UndefVarError nonnothingtype
	@test_throws UndefVarError notnothing
	@test_throws UndefVarError nthreads
	@test_throws UndefVarError OrderedDict
	@test_throws UndefVarError OrderedSet
	@test_throws UndefVarError return_types
	@test_throws UndefVarError TypeofBottom
	@test_throws UndefVarError TypeofVararg
	@test_throws UndefVarError UnfrozenLittleDict

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
	@test_throws MethodError first(only(methods(identity)).sig)
	@test_throws MethodError log10(11, 2)
	@test_throws MethodError ntuple(2, 1)
	@test_throws MethodError repr.(@__MODULE__)
	@test_throws MethodError repr.(MIME("text/plain"))
	@test_throws MethodError repr.(TextDisplay(devnull))
	@test_throws MethodError repr("text/plain", [:_, -1]')
	@test_throws MethodError repr("text/plain", [:p, :q]')
	@test_throws MethodError repr("text/plain", ['1', '2']')
	@test_throws MethodError repr("text/plain", ["x", "y"]')
	@test_throws MethodError repr("text/plain", [r"^", r"$"]')
	a_ua_tuple = Tuple{Vector{T}, Matrix{T}, Array{T, 3}} where T
	a_ua_union = Union{Vector{T}, Matrix{T}, Array{T, 3}} where T
	a2_missing = Array{Missing, 2}(undef, Tuple(rand(0:9, 2)))
	a3_nothing = Array{Nothing, 3}(undef, Tuple(rand(0:9, 3)))
	using Exts

	allowed_undefineds = [
		GlobalRef.(Base, [:active_repl, :active_repl_backend])
		GlobalRef.(Base.MainInclude, [:Distributed, :InteractiveUtils])
	]

	@test (>, <)(0) === (>(0), <(0))
	@test (>, <)(0) isa NTuple{2, Fix2{<:Function, Int}}
	@test (sin, cos)(0) === sincos(0) === (0.0, 1.0)
	@test [:_ -1] == [:_, -1]'
	@test [:p :q] == [:p, :q]'
	@test ['1' '2'] == ['1', '2']'
	@test ["x" "y"] == ["x", "y"]'
	@test [(r"^") (r"$")] == [(r"^"), (r"$")]'
	@test [a_ua_tuple::UnionAll...] == UnionAll[Vector, Matrix, Array{T, 3} where T]
	@test [a_ua_union::UnionAll...] == UnionAll[Vector, Matrix, Array{T, 3} where T]
	@test [AbstractMatrix...] == [Vector...] == Any[]
	@test [AbstractMatrix{UInt8}...] == Any[UInt8, 2]
	@test [AbstractVecOrMat...] == UnionAll[AbstractVector, AbstractMatrix]
	@test [Core.BuiltinInts...] ⊋ DataType[Bool, Int8, Int16, Int32, Int64, Int128]
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
	@test freeze(ODict(1 => 0)) isa LDict{Int, Int}
	@test freeze(ODict{Maybe{UInt}, Datum{Int}}(1 => 10)) isa LDict{UInt, Int}
	@test freeze(ODict{Maybe{UInt}, Datum{Int}}(1 => missing)) isa LDict{UInt, Missing}
	@test getall(iseven, 1:9) == getall(iseven)(1:9) == [2, 4, 6, 8]
	@test getfirst(iseven, 1:9) == getfirst(iseven)(1:9) == 2
	@test getlast(iseven, 1:9) == getlast(iseven)(1:9) == 8
	@test invsqrt(2^-2) == 2
	@test isempty(detect_ambiguities(Core, Base, Exts; recursive = true, allowed_undefineds))
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
	@test repr.(@__MODULE__) === "Main"
	@test repr.(MIME("text/plain")) === "MIME type text/plain"
	@test repr.(TextDisplay(devnull)) === "TextDisplay(Base.DevNull())"
	@test return_type(invsqrt, (Any,)) == AbstractFloat
	@test return_type(iterate, (DataType, Int)) == Maybe{Tuple{Any, Int}}
	@test return_type(iterate, (TypeofBottom,)) == Nothing
	@test return_type(iterate, (Union, DataType)) == Tuple{DataType, TypeofBottom}
	@test return_type(iterate, (Union, TypeofBottom)) == Nothing
	@test return_type(iterate, (Union, Union)) == NTuple{2, Type}
	@test return_type(iterate, (Union, UnionAll)) == Tuple{UnionAll, TypeofBottom}
	@test return_type(iterate, (UnionAll, Type{Any})) == Nothing
	@test return_type(iterate, (UnionAll, TypeofBottom)) == Nothing
	@test return_type(log10, ntuple(2, Any)) == NTuple{2, AbstractFloat}
	@test stdpath("...") == "..."
	@test stdpath("..") == "../"
	@test stdpath(".") == "./"
	@test stdpath("") == ""
	@test Tuple === Tuple{Vararg{Any}} === VTuple{Any}
	@test typeof(identity) === first(only(methods(identity)).sig)
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

	@test collect(Exts.walkdir(" ")) == collect(Exts.walkdir("")) == []
	@test collect(Exts.walkdir("."))[1][1] == "./"
	@test collect(Exts.walkdir("."))[1][2] == filter!(isdir, readdir())
	@test collect(Exts.walkdir("."))[1][3] == filter!(isfile, readdir())
	@test getindex.(Exts.walkdir(), 1) == getindex.(Base.walkdir(pwd()), 1) .|> stdpath
	@test getindex.(Exts.walkdir(), 2) == getindex.(Base.walkdir(pwd()), 2)
	@test getindex.(Exts.walkdir(), 3) == getindex.(Base.walkdir(pwd()), 3)

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

	@static if VERSION < v"1.10"
		@test freeze(Dict()) isa LittleDict{Bottom, Bottom}
		@test return_type(freeze) == LittleDict
	else
		@test return_type(freeze) == FrozenLittleDict
		@test_throws MethodError freeze(Dict())
	end

	ASV = AbstractSlices{S, 1} where {S, N}
	SV = Slices{P, M, X, S, 1} where {P, M, X, S, N}
	@test AbstractVector === promote_type(Vector, SV)
	@test ASV >: SV
	for T ∈ (Vector, Matrix, VecOrMat, Array)
		for R ∈ return_types(ensure_vector, (T,))
			@test R <: SV || R === Vector
		end
	end
	for T ∈ (AbstractVector, AbstractMatrix, AbstractVecOrMat, AbstractArray)
		for R ∈ return_types(ensure_vector, (T,))
			@test R <: SV || R === AbstractVector
		end
	end

	fi, i = mktemp()
	fo, o = mktemp()
	redirect_stdio(stdin = i, stdout = o) do
		write(stdin, '\n'), seekstart(stdin)
		pause(post = 1)
		@eval @test isnothing(@disp VERSION)
	end
	close.((i, o))
	@test readstr(fo) ≡ """
	Press any key to continue . . . \n
	v"$VERSION"
	"""
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
	using FITSIO: FITSIO, CFITSIO, ASCIITableHDU, FITS, TableHDU
	@test ccall((:fits_is_reentrant, CFITSIO.libcfitsio), Bool, ())
	# https://heasarc.gsfc.nasa.gov/fitsio/c/c_user/node15.html

	using HTTP: HTTP
	tmp = HTTP.download(
		"https://data.sdss.org/sas/dr18/spectro/sdss/redux/" *
		"v5_13_2/spectra/lite/3650/spec-3650-55244-0001.fits",
		mktempdir(), update_period = Inf,
	)
	GC.enable(false)
	FITS(f -> @test_throws(ArgumentError,
			read(f["SPALL"], DataFrame)), tmp, "r+")
	FITS(f -> @test_nowarn(
			read(f["SPALL"], DataFrame)), tmp, "r")
	FITS(tmp) do f
		@test 1 === get(f, "XXXXX", 1).ext
		@test 2 === get(f, "COADD", 1).ext
		@test 3 === get(f, "SPALL", 1).ext
		@test 4 === get(f, "SPZLINE", 1).ext
		@test DataFrame(f[2]) == read(f[2], DataFrame)
		@test DataFrame(f[3]) == read(f[3], DataFrame)
		@test DataFrame(f[4]) == read(f[4], DataFrame)
		@test parent.(read(f[2], Vector)) == (read(f[2], Vector{Array}))
		@test parent.(read(f[3], Vector)) == (read(f[3], Vector{Array}))
		@test parent.(read(f[4], Vector)) == (read(f[4], Vector{Array}))
		@test size(read(f[2], DataFrame)) == (4623, 8)
		@test size(read(f[3], DataFrame)) == (1, 236)
		@test size(read(f[4], DataFrame)) == (32, 19)
		SV = Slices{P, M, X, S, 1} where {P, M, X, S, N}
		@test all(@. $read(f[2], Vector) isa Union{Vector, SV})
		@test all(@. $read(f[3], Vector) isa Union{Vector, SV})
		@test all(@. $read(f[4], Vector) isa Union{Vector, SV})
	end
	foreach(_ -> GC.gc(), 1:5)
	@static if haskey(ENV, "CI") && v"1.10" ≤ VERSION < v"1.11" # LTS
		err = @catch for _ ∈ 1:1000
			FITS(f -> read(f[2], Vector), tmp)
			FITS(f -> read(f[3], Vector), tmp)
			FITS(f -> read(f[4], Vector), tmp)
		end
		@test isnothing(err)
		foreach(_ -> GC.gc(), 1:5)
	end
	GC.enable(true)
	for T ∈ subtypes(FITSIO.HDU)
		@test fieldtype(T, :fitsfile) === CFITSIO.FITSFile
		@test fieldtype(T, :ext) === Int
	end
	@test FITSIO.EitherTableHDU === Union{ASCIITableHDU, TableHDU}
	@test return_type(CFITSIO.fits_file_mode) === Cint
	@test return_type(CFITSIO.fits_file_name) === String
	@test return_type(FITSIO.colnames) === Vector{String}
	@test return_type(FITSIO.Tables.columnnames, (TableHDU,)) === Vector{Symbol}
end

@testset "PkgExt" begin
	@test !isdefined(Exts.ext(:Pkg), :Pkg)
	load_path = copy(LOAD_PATH)
	Exts.with_temp_env() do
		@test isnothing(Base.active_project())
		@test LOAD_PATH == ["@", "@stdlib"]
	end
	@test LOAD_PATH == load_path
	@test isdefined(Exts.ext(:Pkg), :Pkg)
end

@testset "StatisticsExt" begin
	using StatsBase: mean, weights
	F64  = Float64
	data = F64[1:20-1; NaN]
	@test mean(1:20, weights(zeros(20))) |> isnan
	@test mean(1:20) === nanmean(1:20, weights(zeros(20)))
	@test mean(data) === nanmean(data, weights(zeros(20)))
	@test mean(data) |> isnan
end

@testset "YAMLExt" begin
	using YAML: yaml
	str = yaml(
		S"name"     => S"CI",
		S"on"       => LDict(:workflow_dispatch => nothing),
		S"defaults" => LDict(:run => Dict(:shell => :bash)),
		S"env"      => LDict(:JULIA_NUM_THREADS => S"auto"),
	)
	@test str === """
	name: CI
	on:\n  workflow_dispatch: ~
	defaults:\n  run:\n    shell: bash
	env:\n  JULIA_NUM_THREADS: auto
	"""
end

@test all(nameof.(last.(Exts.ext(:))) .== first.(Exts.ext(:)))
@static parse(Bool, get(ENV, "CI", "0")) || include("docs.jl")

