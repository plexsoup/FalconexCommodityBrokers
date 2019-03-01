"""

TODO:
	- feb 28: 
		- make inventory limit for player
		- make enemies leave player alone if cargo is empty
		- add upgrade options:
			- lasers, missiles, shield, cargo hold, engines

Notes regarding Design Decisions:
	- Initially, players had to select the delivery destination manually.
		- it's more fun if the game provides a destination randomly
	
	- removed purchase price from commodities. planets kick them out for free now
		- spending money isn't fun, unless it's on ship upgrades

	- initially, all planets would buy your goods.
		- selling now only works for the selected planet
		
	- Considered making planets only take 1 commodity, instead of offering different prices for 3
		- But, I kinda like the spreadsheet-y feel to the sidebar

Minimum Features Required
	- create enemies - done
	- spawn enemeis at intervals - done
	- they attack the player -done	
	- spinning solar systems - done
	- have three type of planets: gear, wheat, diamond - done
	- planets drop loot - done
	- deliver loot to other planets - done
	- create markov planet name generator - done
	- show names of planets - done
	- galaxy boundary to keep player centered - done


Bugs to Fix
	
	- add a pause option
	- html export has double-image
		- maybe because of two viewports.
	
	
	- opening and closing the sidebar selects a planet
	- sometimes the wrong planet is selected
	

	
	
Game-Feel / User Experience Enhancements to Make
	- needs a music track, but I haven't settled on one
		- maybe back to bosca.ceoil or turtle.audio
	- stars could have a self-modulate to make their colors a litle different from each other
	- be nice to have a couple different planets too
	
	- when you hit enemies, the second hit should not show a shield
	
	- make cash popups further apart
	
	- give enemy more behaviour.. 
		- vector move towards commodities
		
	
"""

extends Node
