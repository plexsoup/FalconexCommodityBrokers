"""

Playtest Feedback:
	- TigerJ = too hard
	- Joshua McLean 
		- needs more stars
		- ship's too fast
		- audio levels are terrible.. why would I allow clipping?
			- I don't know how to prevent that.
		- What's my goal?
		- when you zoom out, you can't tell what direction you're facing.
			- maybe make the ship a triangle shap, so it looks good zoomed
			(or have an alternate sprite like I did with cactus notes)
		
	(both basically gave up without any upgrades. That's a problem.)
	
	- needs help menu or popup tips
	- ship should be capsule collision, not rect
	
		
TODO:
	- mar 1: 
	
		polish.
		give enemy ai behaviour = shoot if shot at.
		test html export
		

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
	
	
	- sometimes the selected planet won't accept sale.
		 - it gets deselected somehow.
		- problem seems to be with specific planets. Not all the stars in the same system
		- the planet appears to be selected properly, then the selection switches to null.
	
	
	- opening and closing the sidebar selects a planet
	- sometimes the wrong planet is selected
	

	
	
Game-Feel / User Experience Enhancements to Make
	- auto-open the sidebar when you have enough cash?
	
	
	- be nice to have a couple different planets too
	
	- when you hit enemies, the second hit should not show a shield
	
	- make cash popups further apart
	
	- give enemy more behaviour.. 
		- vector move towards commodities
		
	
"""

extends Node
