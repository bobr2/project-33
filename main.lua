local gamera = require('gamera')

function love.load()
    imageData = love.image.newImageData('town12.png')
    city = love.graphics.newImage(imageData)
    cityh = city:getHeight()
    cityw = city:getWidth()
    grassh = cityh - 60
    cam = gamera.new(0, 0, cityw, cityh)
  
    --success = love.window.setFullscreen( true )
    cam:setWindow(0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    
    imageData1 = love.image.newImageData('PNG/sadboy.png')
    sadboy = love.graphics.newImage(imageData1)
    sadboyw = sadboy:getWidth()
    sadboyh = sadboy:getHeight() 
    
    imageData2 = love.image.newImageData('nps.png')
    nps = love.graphics.newImage(imageData2)
    npsw = nps:getWidth()
    npsh = nps:getHeight()
    
     
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

    lastime = love.timer.getTime( )
end
function love.mousepressed(x, y, button, istouch, presses) mp = true end

function love.mousereleased(x, y, button, istouch, presses) mp = false end

function love.mousemoved(x, y, dx, dy, istouch)
    if mp then
        local camx, camy = cam:getPosition()

        cam:setPosition(camx - dx, camy - dy)
    end
end

function love.draw()
    cam:draw(function(l, t, w, h)
        love.graphics.draw(city, 0, 0, 0) 
        love.graphics.draw(sadboy, sadboyb:getX(), sadboyb:getY(), 0, 1, 1, sadboyw/2, sadboyh/2)
        love.graphics.draw(nps, npsb:getX(), npsb:getY(), 0, 1, 1, npsw/2, npsh/2)
         
    end)
    world:update(0.1)

    time = love.timer.getTime( )
    if time - lastime > 1 then
        lastime = love.timer.getTime()

    local dx = wallc:getX() - npsb:getX()
    local dy = wallc:getY() - npsb:getY()
    if dx < 0 then dx = -1 else dx = 1 end
    npsb:applyLinearImpulse( dx*50, 0)
    end
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
