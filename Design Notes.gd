"""

	
		
TODO:
	Pickups just stay put, seems weird: consider giving collectibles (wheat, gems, etc.) some movement vectors..
	Edge of Galaxy is hard and bouncy, seems weird. Consider a warning about deep space instead. maybe multiple galaxies?
	Engine audio hurts my ears. fudge factor it down -24 db
	Engine audio doesn't respect master volume control options.
	Master volume control options allows player to set them way too high.


Notes regarding Design Decisions:
	- What reason does the player have to not shoot?
		- make some innocent delivery ships?
		- make a battery for the lasers and ammo count for missiles?
	
	
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
	- bottom panel should unpause when closed with BottomPanelButton
	
	- opening and closing the sidebar selects a planet
	- sometimes the wrong planet is selected
	
Bugs fixed:
	engines are faster if the computer is faster.
	- inputs weren't taking framerate (delta) into consideration

	
	
Game-Feel / User Experience Enhancements to Make
	- cargo container is awesome, but needs tweaking
		- set it so it can collide with parent
		- if it collides with enemies it should deal damage (hammerfight)
		- maybe make it a bit longer and bigger?

	- with every upgrade, there should be an incoming transmission
		(dialog box) about how we expect FalconEx pilots to get goods
		to their destinations quickly. Therefore, we've provided you with
		free engine upgrades. -- ramp up the speed automatically
		- if you need to, you can install dampeners for cash ('upgrade which reduces speed') 

	- add dampeners or brakes as an upgrade
	
	- every storage upgrade should add a train car

	- players don't know what their goals are:
		- make a popup that checks various conditions and provides tips
			- no inventory after x time, say WASD to fly. Run into planets to extract commodities
			- have inventory, but no money after x time, say choose a planet from the market list, then fly there to sell goods
			- never pressed space, say press space to shoot
			
			- later, we can use this as the basis of the quest system
				- People are starving on planet xyz. Bring food.
				- Research has stalled on planet.. bring cogs
				- luxury planet demands more diamonds
				
			- later, quests could include defending or attacking planets or planetary raids.

			
	- when you hit esc, should all the panels open?
	
	- now that the ship is slower, the game seems a bit easy.. 
		- how can we add more challenge that players are OK with?
	
	- be nice to have a couple different planets too
	- when you hit enemies, the second hit should not show a shield
	- make cash popups further apart
	- give enemy more behaviour.. 
		- vector move towards commodities
		
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
	
"""

extends Node
