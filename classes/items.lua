require("classes.enemies")
require("classes.level")
require("classes.move")
require("classes.chop")
--equire("classes.heroes")
local globals = require("classes.globals")
local storyboard = require( "storyboard" )
--require("scenes.scene_ingame")
Item = {}
Item.__index = Item

local startX = nil
local startY = nil


function Item.makeItem(name, itemType, image, cost, id, unlocked)
	local item = {}             -- our new object
	setmetatable(item,Item)
	item.name = name
	item.itemType = itemType
	item.image = image
	item.cost = cost
	item.id = id
	item.unlocked = unlocked
	return item
end

items = {}
function makeItemArray ()
	local nextItem
	items[0] = nil
	for i = 1,table.maxn( myEnemies )+1 do
		items[i] = myEnemies[i-1]
		items[i].itemType = "foodType"
		items[i].cost = 500
		items[i].id = i
		items[i].foodId = i-1
		items[i].unlocked = true
		nextItem=i
	end
	--nextItem=nextItem+1
	items[nextItem+1]= Item.makeItem("Commercial Break","break", "images/rightArrow.png", 1000, nextItem, false)
	items[nextItem+2]= Item.makeItem("Compost","trash", "images/trash_item.png", 1200, nextItem+2, false)
	items[nextItem+3]= Item.makeItem("Producer Swap","swap", "images/swap.png", 700, nextItem+3, false)
	items[nextItem+4]= Item.makeItem("Attack Boost","boost", "images/attackboost.png", 800, nextItem+4, false)
	items[nextItem+5]= Item.makeItem("Chop Food","chop", "images/chop.png", 1000, nextItem+5, false)
end
makeItemArray()
myItems = {}
myItems[0] = nil
myItems[1] = nil
myItems[2] = nil
--Not being used
function useItem(hero)
	local item = hero.item
	if ( item == nil ) then emptyItem()
	elseif ( item.id > 0 ) then foodItem(item, hero)
	end
	
end
--not being used
function emptyItem()
	print ("You got nothin")
end
--not being used
function foodItem(item, hero)
	--createEne(item.foodId)
	print(item.name)
	hero.item = nil
end

function passValuesToNewItem ( newItem, oldItem )
	-- if the new item is an enemy/foodtype, use the enemy's passing valurs function from the enemy class
	if ( oldItem.itemType == "foodType" ) then
		newItem = passValuesToNewEne( newItem, oldItem )
	end
	newItem.name = oldItem.name
	newItem.itemType = oldItem.itemType
	newItem.image = oldItem.image
	newItem.cost = oldItem.cost
	newItem.id = oldItem.id
	newItem.unlocked = oldItem.unlocked
	return newItem
end

function commercialBreak()
	storyboard.showOverlay("scenes.scene_break", {effect = "slideDown", time=500})
    timer.pause(attackTimer)
    timer.pause(spawnEneTimer)
    if (antagonistTimer ~= nil) then
		timer.pause(antagonistTimer)
	end
    transition.pause("animation")
end

function producerSwap()
	if ( table.maxn(allEne)>1 ) then
		local randomEne1 = math.random(1, table.maxn( allEne  ) )
		local randomEne2 = math.random(1, table.maxn( allEne  ) )
		while (randomEne1 == randomEne2) do
			randomEne1 = math.random(1, table.maxn( allEne  ) )
			randomEne2 = math.random(1, table.maxn( allEne  ) )
		end
		local randomEne1X = allEne[randomEne1].x
		local randomEne2X = allEne[randomEne2].x
		print ("enemy1 x: " .. randomEne1X .. " enemy2 x: " .. randomEne2X)
		local randomEne1BarX = allEnemHealth[randomEne1].x
		local randomEne2BarX = allEnemHealth[randomEne2].x
		local randomEne1Y = allEne[randomEne1].y
		local randomEne2Y = allEne[randomEne2].y
		local randomEne1BarY = allEnemHealth[randomEne1].y
		local randomEne2BarY = allEnemHealth[randomEne2].y
		
		local smoke1 = display.newImage( "images/smoke.png", allEne[randomEne1].x, allEne[randomEne1].y, true )
		transition.to( smoke1, { time=1500, alpha=0, onComplete=function() smoke1:removeSelf()end } )
		
		local smoke2 = display.newImage( "images/smoke.png", allEne[randomEne2].x, allEne[randomEne2].y, true )
		transition.to( smoke2, { time=1500, alpha=0, onComplete=function() smoke2:removeSelf()end } )
		local function resetMove()
			transition.to( allEne[randomEne1], { time=(moveSpeed(allEne[randomEne1].x, allEne[randomEne1].speed, allEne[randomEne1].y)), x=(50) ,tag="animation"}  )
			transition.to( allEne[randomEne2], { time=(moveSpeed(allEne[randomEne2].x, allEne[randomEne2].speed, allEne[randomEne2].y)), x=(50) ,tag="animation"}  )
			transition.pause("animation")
		end
		transition.to(allEne[randomEne1], { time= 2000,  x = randomEne2X, y = randomEne2Y})
		transition.to(allEne[randomEne2], { time= 2000,  x = randomEne1X, y = randomEne1Y, onComplete= resetMove })
	end
end

  local function resume()
  	print("CHOP ENDING")
		for i = 0,table.maxn( allEne ) do
			if (allEne[i] ~= nil) then
				allEne[i]:removeEventListener( "touch", chopping )
    			allEne[i]:addEventListener( "touch", teleport )
   			end
		end
  end

function chopFood()
	print("CHOP FOOD!!")
	timer.performWithDelay( 6000, resume )
   		for i = 0,table.maxn( allEne ) do
   			if (allEne[i] ~= nil) then
    			allEne[i]:removeEventListener( "touch", teleport )
    			allEne[i]:addEventListener( "touch", chopping )
    		end
		end
end


function itemTap ( event )
	itemUsed = event.target
	-- if the item is "break", call the commercialBreak function
	if (itemUsed.itemType == "break") then
		commercialBreak()
		itemUsed: removeSelf()
		myItems[itemUsed.myItemRef] = nil
	elseif (itemUsed.itemType == "swap")then
		producerSwap()
		itemUsed: removeSelf()
		myItems[itemUsed.myItemRef] = nil
	elseif (itemUsed.itemType == "chop")then
		chopFood()
		itemUsed: removeSelf()
		myItems[itemUsed.myItemRef] = nil
	end
end

function itemFoodDrag( event )
	local body = event.target
	local phase = event.phase
	local stage = display.getCurrentStage()
	if( startX == nil ) then
		startX = body.x
		startY = body.y
	end

	if "began" == phase then
		stage:setFocus( body, event.id )
		body.isFocus = true

	elseif body.isFocus then
		if "moved" == phase then

		-- Update the joint to track the touch
		body.x = event.x
		body.y = event.y 

		elseif "ended" == phase or "cancelled" == phase then
			local hit = 0
			print (body.itemType)
			for n = 0,table.maxn( allEne  ) do
				if ( hasCollidedCircle( body, allEne[n]) ) then
					-- in game
					if (body.itemType == "foodType") then
						itemCombo( body, allEne[n], true )
						break
					elseif (body.itemType == "trash") then
					allEne[n]: removeSelf()
					table.remove(allEne, n)
					allEnemHealth[n]:removeSelf()
					table.remove(allEnemHealth, n)
					decrementEnemy(currentLevel)
					body: removeSelf()
					myItems[body.myItemRef] = nil
					end
				hit = 1
				end
			end
			if ( hit == 0) then
				print (body.x .. " " .. startX)
				transition.to( body, { time=400, x = startX, y = startY} )
			end
			startX = nil
			startY = nil
			stage:setFocus( body, nil )
			body.isFocus = false

		end
	end

-- Stop further propagation of touch event
	return true
end

function dragToHero( event )
	local body = event.target
	local phase = event.phase
	local stage = display.getCurrentStage()
	if( startX == nil ) then
		startX = body.x
		startY = body.y
	end

	if "began" == phase then
		stage:setFocus( body, event.id )
		body.isFocus = true

	elseif body.isFocus then
		if "moved" == phase then

		-- Update the joint to track the touch
		body.x = event.x
		body.y = event.y 

		elseif "ended" == phase or "cancelled" == phase then
			local hit = 0
			print (body.itemType)
			for n = 0,table.maxn( hero  ) do
				if ( hasCollidedCircle( body, hero[n]) ) then
					-- in game
					if (body.itemType == "boost") then
						hero[n].attack = hero[n].attack + 2
						print(hero[n].attack)
						body: removeSelf()
						myItems[body.myItemRef] = nil
					end
				hit = 1
				end
			end
			if ( hit == 0) then
				print (body.x .. " " .. startX)
				transition.to( body, { time=400, x = startX, y = startY} )
			end
			startX = nil
			startY = nil
			stage:setFocus( body, nil )
			body.isFocus = false

		end
	end

-- Stop further propagation of touch event
	return true
end