local gamera = require('gamera')

function love.load()
    imageData = love.image.newImageData('town12.png')
    city = love.graphics.newImage(imageData)
    cityh = city:getHeight()
    cityw = city:getWidth()
    grassh = cityh - 60
    cam = gamera.new(0, 0, cityw, cityh)

    
  
    success = love.window.setFullscreen( true )
    cam:setWindow(0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    
    imageData1 = love.image.newImageData('PNG/sadboy.png')
    sadboy = love.graphics.newImage(imageData1)
    sadboyw = sadboy:getWidth()
    sadboyh = sadboy:getHeight() 
    
    imageData2 = love.image.newImageData('nps.png')
    nps = love.graphics.newImage(imageData2)
    npsw = nps:getWidth()
    npsh = nps:getHeight()
    
   -- coinM = love.image.newImageData('coinM.png')
   -- coinn = love.graphics.newImage(coinM)
   -- coinW = coinn:getWidth()
   -- coinH = coinn:getHeight()
    --coinb = love.physics.newBody( world, 100, 100, 'static' )
    --coinhit = love.physics.newRectangleShape( coinW, coinH)

     
    world = love.physics.newWorld( 0, 10, true )
    grass = love.physics.newBody( world, 0, grassh, 'static')
    grasshit = love.physics.newEdgeShape( 0, 0, cityw, 0 )
    grassfix = love.physics.newFixture( grass, grasshit)
    wall = love.physics.newBody( world, 0, 0, 'static')

    wallhit = love.physics.newEdgeShape( 0, 0, 0, 10000 )
    wallfix = love.physics.newFixture( wall, wallhit)

    wallr = love.physics.newBody( world, cityw, 0, 'static')
    wallhitr = love.physics.newEdgeShape( 0, 0, 0, 10000 )
    wallfixr = love.physics.newFixture( wallr, wallhitr)

    wallc = love.physics.newBody( world, cityw/2, 0, 'static')
    wallhitc = love.physics.newEdgeShape( 0, 0, 0, 10000 )
    wallfixc = love.physics.newFixture( wallc, wallhitc)

    sadboyb = love.physics.newBody( world, 100, 100, 'dynamic' )
    sadboyhit = love.physics.newRectangleShape( sadboyw, sadboyh )
    sadboyfix = love.physics.newFixture( sadboyb, sadboyhit)

    npsb = love.physics.newBody( world, cityw-100, 100, 'dynamic' )
    npshit = love.physics.newRectangleShape( npsw, npsh )
    npsfix = love.physics.newFixture( npsb, npshit)

    imageData3 = love.image.newImageData('solder.png')
    solder = love.graphics.newImage(imageData3)

    imageData4 = love.image.newImageData('bul.png')
    bul = love.graphics.newImage(imageData4)
    bulb = love.physics.newBody( world, cityw/2 + 300, cityh/2 +250, 'dynamic' )
    bulh = bul:getHeight()
    bulw = bul:getWidth()
    bulhit = love.physics.newRectangleShape( bulw, bulh )
    bulfix = love.physics.newFixture( bulb, bulhit)





    lastime = love.timer.getTime( )
    gmnimcoin = 0
    gcoin = 0
    hpwallc = 100 
end
function love.mousepressed(x, y, button, istouch, presses) mp = true end

function love.mousereleased(x, y, button, istouch, presses) mp = false end



pos = false


function love.mousemoved(x, y, dx, dy, istouch)
    if mp then
        xc = love.mouse.getX()
        yc = love.mouse.getY()
        if xc > 100 then
            if xc < 150 then
                if yc > 100 then
                    if yc < 150 then
                    gcoin = gcoin + gmnimcoin
                    gmnimcoin = 0
                    end
                end
            end
        end
        local camx, camy = cam:getPosition()
         
        if xc < 300 then
            if xc < 350 then
                if yc > 100 then
                    if yc < 150 then
                        if gcoin > 10 then
                            pos = true
                        end
                    end
                end
            end
        end                    


                    
                
                


        cam:setPosition(camx - dx, camy - dy)
    end
end






dt = love.timer.getAverageDelta( )
function love.update(dt)
    world:update(dt*5)

    time = love.timer.getTime()

    --if time - lastime > 5 then
    --    lastime = love.timer.getTime()
   --     gcoin = gcoin + 1
    --end


    if time - lastime > 1 then 
        lastime = love.timer.getTime()
        gmnimcoin = gmnimcoin + 1

        if not npsb:isDestroyed() then
            local dx = wallc:getX() - npsb:getX()
            local dy = wallc:getY() - npsb:getY()
            if dx < 0 then dx = -1 else dx = 1 end

            npsb:applyLinearImpulse( dx*200, 0)
        end

        if not bulb:isDestroyed() then
            local dx = npsb:getX() - bulb:getX()
            local dy = npsb:getY() - bulb:getY()
            if dx < 0 then dx = -1 else dx = 1 end

            bulb:applyLinearImpulse( dx*200, 0)
        end
        
    end

    local contacts = world:getContacts( )
    for _, contact in ipairs(contacts) do
        fixtureA, fixtureB, fixtureC, fixtureD = contact:getFixtures( )
        
        
        if fixtureB == npsfix then
            if fixtureA == wallfixc then
                hpwallc = hpwallc - 10

                npsb:destroy()
                break
            end
        end

        if fixtureC == bulfix then
            if fixtureD == npsfix then
                npsb:destroy()
                bulb:destroy()
                break
            end
        end
        
    end
    

    

    if bulb:isDestroyed() then
        bulb = love.physics.newBody( world, cityw-100, 100, 'dynamic' )
        bulhit = love.physics.newRectangleShape( bulw, bulh )
        bulfix = love.physics.newFixture( bulb, bulhit)
    end


    if npsb:isDestroyed() then
        npsb = love.physics.newBody( world, cityw-100, 100, 'dynamic' )
        npshit = love.physics.newRectangleShape( npsw, npsh )
        npsfix = love.physics.newFixture( npsb, npshit)
    end

    if hpwallc < 0 then
        hpwallc = 0

        love.graphics.print('BooM', 0, 0)
    end




end


function love.draw()
    cam:draw(function(l, t, w, h)
        love.graphics.draw(city, 0, 0, 0) 
        --love.graphics.draw(coinn, coinb:getX(100), coinb:getY(100), 0)
        love.graphics.draw(sadboy, sadboyb:getX(), sadboyb:getY(), 0, 1, 1, sadboyw/2, sadboyh/2)
        if not npsb:isDestroyed() then
            love.graphics.draw(nps, npsb:getX(), npsb:getY(), 0, 1, 1, npsw/2, npsh/2)
             
        end
        

        if pos == true then
            love.graphics.draw(solder, cityw/2 + 200, cityh/2 +300)

            if not npsb:isDestroyed() then
                love.graphics.draw(bul, bulb:getX(), bulb:getY(), 0, 1, 1)
                 
            end
            
            
                 
            
        end    

        love.graphics.rectangle("fill", 100, 100, 50, 50, 0, 0, segments )
        love.graphics.rectangle("fill", 300, 100, 50, 50, 0, 0, segments )
    end)

    love.graphics.print('hp = ' .. tostring(hpwallc), 0, 0)
    love.graphics.print('coin = ' .. tostring(gcoin), 0, 30)

    

end

function love.keyreleased(key)
    if key == "space" then
        sadboyb:applyLinearImpulse( 0, -1000 )
    elseif key == 'd' then
        sadboyb:applyLinearImpulse( 1000, 0 )
    elseif key == 'a' then
        sadboyb:applyLinearImpulse( -1000, 0 )
    end
end

function love.wheelmoved(x, y)
    local scale = cam.scale
    if y > 0 then
        cam:setScale(scale*1.1)
    elseif y < 0 then
        cam:setScale(scale*0.9)
    end
    
    local x, y = cam:toWorld(love.mouse.getX( ), love.mouse.getY( ))
    cam:setPosition(x, y)
end

