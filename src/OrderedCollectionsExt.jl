# Copyright (C) 2024 Heptazhou <zhou@0h7z.com>
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

module OrderedCollectionsExt

using Base: isbitsunion, unwrap_unionall
using OrderedCollections: OrderedCollections, OrderedDict, _tablesz, hashindex, rehash!

@static if [unwrap_unionall(methods(rehash!, (OrderedDict, Int))[1].sig)...][3] == Any
#! format: noindent
function OrderedCollections.rehash!(h::OrderedDict{K, V}, newsz::Integer) where {K, V}
	olds = h.slots
	keys = h.keys
	vals = h.vals
	sz = length(olds)
	newsz = _tablesz(newsz)
	h.dirty = true
	count0 = length(h)
	if count0 == 0
		resize!(h.slots, newsz)
		fill!(h.slots, 0)
		resize!(h.keys, 0)
		resize!(h.vals, 0)
		h.ndel = 0
		return h
	end
	slots = zeros(Int32, newsz)
	maxprobe = 0
	if h.ndel > 0
		ndel0 = h.ndel
		ptrs = !isbitstype(K) && !isbitsunion(K)
		to = 1
		newkeys = similar(keys, count0)
		newvals = similar(vals, count0)
		@inbounds for from ∈ 1:length(keys)
			if !ptrs || isassigned(keys, from)
				k = keys[from]
				hashk = hash(k) % Int
				isdeleted = false
				if !ptrs
					iter = 0
					index = (hashk & (sz - 1)) + 1
					while iter <= h.maxprobe
						si = olds[index]
						si == from && break
						(si == -from || si == 0) && (isdeleted = true; break)
						index = (index & (sz - 1)) + 1
						iter += 1
					end
					iter > h.maxprobe && (isdeleted = true)
				end
				if !isdeleted
					index0 = index = (hashk & (newsz - 1)) + 1
					# COV_EXCL_START
					while slots[index] != 0
						index = (index & (newsz - 1)) + 1
					end
					# COV_EXCL_STOP
					probe = (index - index0) & (newsz - 1)
					probe > maxprobe && (maxprobe = probe)
					slots[index] = to
					newkeys[to] = k
					newvals[to] = vals[from]
					to += 1
				end
				if h.ndel != ndel0
					return rehash!(h, newsz) # COV_EXCL_LINE
				end
			end
		end
		h.keys = newkeys
		h.vals = newvals
		h.ndel = 0
	else
		@inbounds for i ∈ 1:count0
			k = keys[i]
			index0 = index = hashindex(k, newsz)
			# COV_EXCL_START
			while slots[index] != 0
				index = (index & (newsz - 1)) + 1
			end
			# COV_EXCL_STOP
			probe = (index - index0) & (newsz - 1)
			probe > maxprobe && (maxprobe = probe)
			slots[index] = i
			if h.ndel > 0
				return rehash!(h, newsz) # COV_EXCL_LINE
			end
		end
	end
	h.slots = slots
	h.maxprobe = maxprobe
	return h
end
end

end # module

