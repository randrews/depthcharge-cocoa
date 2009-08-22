#
#  Util.rb
#  DepthCharge
#
#  Created by Ross Andrews on 8/20/09.
#  Copyright (c) 2009 Home. All rights reserved.
#

module Util

	def cmap c, &block
		{:x => block[c[:x]], :y => block[c[:y]]}
	end

	def whichWay start, endp 
		delta = cmap(:x => endp[:x]-start[:x], :y => endp[:y]-start[:y]){|n| Math.abs n}

		return :h_then_v if delta[:x]>delta[:y]
		return :v_then_h if delta[:x]<delta[:y]
		return :diag
	end

	def goH curr, goal
		if curr[:x] < goal[:x]
			curr.x += 1
		elsif curr[:x] > goal[:x]
			curr.x -= 1
		end
	end

	def goV curr, goal
		if curr[:y] < goal[:y] 
			curr.y += 1
		elsif curr[:y] > goal[:y]
			curr.y -= 1
		end
	end

=begin
function path(start, end){
	var way=whichWay(start,end);
	var curr={x:start.x, y:start.y};
	if(way=='diag'){
		return function(){
			if(same(curr,end))return null;
			goH(curr,end);
			goV(curr,end);
			return copy(curr);
		}
	} else if(way=='h-then-v'){
		return function(){
			if(same(curr,end))return null;
			if(curr.x! = end.x)goH(curr,end);
			else goV(curr,end);
			return copy(curr);
		}
	} else if(way=='v-then-h'){
		return function(){
			if(same(curr,end))return null;
			if(curr.y! = end.y)goV(curr,end);
			else goH(curr,end);
			return copy(curr);
		}
	}
}
=end

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

=begin
function distance(start,end){
	var p=path(start,end);
	var c=p();
	var cnt=0;
	
	while(c!=null){
		cnt++;
		if(!same(c,end) && isBlocked(c))return null;
		c=p();
	}
	return cnt;
}


function setupBlocks(){
	blocks=[];
	for(i in islands){
		var isle=islands[i];
		blocks[isle.coord.y*12+isle.coord.x]=true;
	}
	for(i in mines){
		var m=mines[i];
		blocks[m.coord.y*12+m.coord.x]=true;
	}
}


function isBlocked(c){
	if(blocks==null)setupBlocks();
	return blocks[c.y*12+c.x]!=null;
}


function getReturns(c){
	var ret=[];
	for(i in mines){
		var m=mines[i];
		var d=distance(c,m.coord);
		if(d)ret[ret.length]=d;
	}
	return unique(ret).sort();
}

function unique(a){
	var r=[];
	for(i in a){
		var t=a[i];
		if(!contains(r,t))
			r[r.length]=t;
	}
	return r;
}

function contains(arr,n){
	for(i in arr)
		if(arr[i]==n)return true;
	return false;
}

function removeMineAt(coord){
	for(i in mines){
		var x=i;
		var m=mines[x];
		if(same(m.coord,coord)){
			mines[x]=mines[mines.length-1];
			mines.length--;
			break;
		}
	}
}
/////////////// RNG from andrew@hedges.name //////////////////////
rnd.today = new Date();
rnd.seed  = rnd.today.getTime();

function rnd() {
   rnd.seed = (rnd.seed*9301+49297) % 233280;
   return rnd.seed/(233280.0);
}

function rand(number) {
   return Math.floor(rnd()*number);
}
//////////////////////////////////////////////////////////////////
=end
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
