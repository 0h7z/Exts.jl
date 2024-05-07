# Copyright (C) 2024 Heptazhou <zhou@0h7z.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

using Test

@testset "BaseExt" begin
	@test_throws MethodError log10(11, 2)
	@test_throws MethodError repr([:a, 1]')
	@test_throws UndefVarError invsqrt(1.0)
	using Exts

	@test [:_ -1] == [:_, -1]'
	@test [:p :q] == [:p, :q]'
	@test ['1' '2'] == ['1', '2']'
	@test ["x" "y"] == ["x", "y"]'
	@test invsqrt(2^-2) == 2
	@test_nowarn log10(11, 2)
end

@testset "DataFramesExt" begin
	using DataFrames: DataFrame
	df  = DataFrame(rand(Int16, (8, 2)), :auto)
	tmp = tempname()
	@test_nowarn write(tmp, df)
	@test read(tmp, DataFrame) == df
end

@testset "StatisticsExt" begin
	using StatsBase: mean, weights
	@test mean(1:20, weights(zeros(20))) |> isnan
	@test mean(1:20) === nanmean(1:20, weights(zeros(20)))
end

