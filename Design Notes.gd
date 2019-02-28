"""

TODO:
	- feb 28: 
		- make inventory limit for player
		- make enemies leave player alone if cargo is empty
		- add upgrade options:
			- lasers, missiles, shield, cargo hold, engines

Notes regarding Design Decisions:
	- removed purchase price from commodities. planets kick them out for free now
		- spending money isn't fun, unless it's on ship upgrades
	- it's very easy to bump into the wrong planet..
		- selling should only work for the planet you have selected in the list
	- instead of having 3 prices. Make planets only buy 1 type of commodity.
	

Features Required
	- create enemies
	- spawn enemeis at intervals
	- they attack the player
	
	- spinning solar systems - done
	- have three type of planets: gear, wheat, diamond - done
	- planets drop loot - done
	- deliver loot to other planets - done
	- create markov planet name generator - done
	- show names of planets - done
	- galaxy boundary to keep player centered - done


Bugs to Fix
	
	
	- opening and closing the sidebar selects a planet
	- sometimes the wrong planet is selected
	
	
	
Game-Feel / User Experience Enhancements to Make
	- when you sell, remove your compass target
	- make cash popup spawn a bit closer
	
	- give enemy more behaviour.. 
		- dont shoot player unless they have serious cargo
		- vector move towards commodities
		- appoint a scooper and a flanker?

	- add a bounce noise to planets?
	- add a tween to commodity spawning

"""

extends Node
