local utf8 = require("utf8")
local sti = require "sti"
local HC = require "HardonCollider"

local hero
local collider
local allSolidTiles

function love.load()
   map = sti.new("map2")
   
   -- load HardonCollider, set callback to on_collide and size of 100
       
   collider = HC(100, on_collide)
        
    -- find all the tiles that we can collide with
    
   allSolidTiles = findSolidTiles(map)
   
  
   
    -- set up the hero object, set him to position 32, 32
  
   setupHero(32,32)
   
end
 
function love.textinput(t)

end
 
function love.update(dt)
   map:update(dt)
   handleInput(dt)
   
  
   
   -- update the collision detection
   collider:update(dt)
end

function love.keypressed(key)
 end
 
function love.draw()

   -- for _, hey in ipairs(allSolidTiles) do
   --    love.graphics.setColor(255, 0, 0)
   --    hey:draw('fill')
   -- end   

   map:draw()   
   love.graphics.setColor(0, 255, 0)
   
   
   --   map:draw()
   -- draw the hero as a rectangle   
   hero:draw("fill")
end

function love.resize(w, h)
   map:resize(w, h)
end



function findSolidTiles(map)


   local collidable_tiles = {}

   
   local layer = map.layers.ground
      for y = 1, layer.height do
         for x = 1, layer.width do
            local tile = layer.data[y][x]

               if tile.id == 6 then
                  local ctile = collider:addRectangle((x-1)*32,(y-1)*32,32,32)                  
                  ctile.type = "tile"
                  collider:addToGroup("tiles", ctile)
                  collider:setPassive(ctile)
                  table.insert(collidable_tiles, ctile)
               end               
               
   
    
         end
   end
               
   return collidable_tiles
end



function setupHero(x,y)

   hero = collider:addRectangle(x,y,32,16)
   hero.speed = 50
   
end


function handleInput(dt)
   if love.keyboard.isDown("left") then
      hero:move(-hero.speed*dt, 0)
      
      
   end
   if love.keyboard.isDown("right") then
      hero:move(hero.speed*dt, 0)
   end
   if love.keyboard.isDown("up") then
      hero:move(0, - hero.speed*dt)
   end

   if love.keyboard.isDown("down") then
      hero:move(0, hero.speed*dt)
   end   
end




function on_collide(dt, shape_a, shape_b, mtv_x, mtv_y)


   print("collision")
   collideHeroWithTile(dt, shape_a, shape_b, mtv_x, mtv_y)
   
   
   
   end
   
   
   
function collideHeroWithTile(dt, shape_a, shape_b, mtv_x, mtv_y)



   -- sort out which one our hero shape is
   
   local hero_shape, tileshape
   
   if shape_a == hero and shape_b.type == "tile" then
      
      hero_shape = shape_a
      
   elseif shape_b == hero and shape_a.type == "tile" then
      
      hero_shape = shape_b
      
   else
      
      -- none of the two shapes is a tile, return to upper function
      
      return
         
   end
   
   
   
   -- why not in one function call? because we will need to differentiate between the axis later
   
   hero_shape:move(mtv_x, 0)
   
   hero_shape:move(0, mtv_y)

end   
