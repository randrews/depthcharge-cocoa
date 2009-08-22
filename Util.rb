#
#  Util.rb
#  DepthCharge
#
#  Created by Ross Andrews on 8/20/09.
#  Copyright (c) 2009 Home. All rights reserved.
#

require 'set'

module Util

	def whichWay start, endp 
		delta = {:x => (endp[:x]-start[:x]).abs, :y => (endp[:y]-start[:y]).abs }

		return :h_then_v if delta[:x]>delta[:y]
		return :v_then_h if delta[:x]<delta[:y]
		return :diag
	end

	def goH curr, goal
		if curr[:x] < goal[:x]
			curr[:x] += 1
		elsif curr[:x] > goal[:x]
			curr[:x] -= 1
		end
	end

	def goV curr, goal
		if curr[:y] < goal[:y] 
			curr[:y] += 1
		elsif curr[:y] > goal[:y]
			curr[:y] -= 1
		end
	end

	def along_path start_c, end_c, &block
		way = whichWay start_c, end_c
		curr = start_c.dup
		
		while curr != end_c
			case way
			when :diag
				goH curr, end_c
				goV curr, end_c
			when :h_then_v
				if curr[:x] != end_c[:x]
					goH curr, end_c
				else
					goV curr, end_c
				end
			when :v_then_h
				if curr[:y] != end_c[:y]
					goV curr, end_c
				else
					goH curr, end_c
				end
			end

			yield curr
		end
	end


	def randomCoords num, maxx=12, maxy=12
		used={}
		coords=[]

		while coords.length < num
			x = rand maxx
			y = rand maxy
			unless used[x+y*maxx]
				used[x+y*maxx]=true;
				coords << {:x => x, :y => y}
			end
		end

		coords
	end

	def distance start_c, end_c
		cnt = 0
		
		along_path start_c, end_c do |c|
			cnt += 1
			return nil if c != end_c and isBlocked(c)
		end
		
		cnt
	end

	def isBlocked c
		b = Set.new
		(islands + mines).each do |blocker|
			b << blocker[:coord]
		end

		b.to_a.include? c # Set.include? doesn't use ==
	end

	def getReturns c
		ret = self.mines.map do |m|
			distance(c,m[:coord])
		end
		
		ret.compact.uniq.sort.reject{|n| n==0 }
	end

	def makeIsland coord
		{ :name => "island#{rand(4)+1}",
		  :angle => 90*rand(4),
		  :coord => coord }
	end

	def findSpaceIn coord, spaces
		spaces.find do |s|
			s[:coord][:x]==coord[:x] and s[:coord][:y]==coord[:y]
		end
	end
end
