--[[
    https://www.freepik.com/free-vector/neon-grid-background_4394259.htm#query=gaming%20background&position=21&from_view=keyword&track=ais&uuid=c36cd1f8-ba77-4f1f-be03-90d0a836e160
    Image by rawpixel.com on Freepik

    https://www.freepik.com/free-vector/magic-ball-with-electric-lightning-inside-realistic_6055215.htm#fromView=search&page=1&position=16&uuid=e9bad309-48f9-4c3a-83ed-82de82729f2d
    Image by upklyak on Freepik
]]

function love.load()
    local _BACKGROUND_IMAGE = "sprites/4394259_91657.jpg"
    local _BALL_IMAGE = "sprites/207.png"
    
    scoreFontSize = 50
    scoreFont = love.graphics.newFont(scoreFontSize)

    -- Sprites
    sprites = {}
    sprites.background = love.graphics.newImage(_BACKGROUND_IMAGE)
    sprites.ball = love.graphics.newImage(_BALL_IMAGE)

    -- Background
    background = {}
    background.image = sprites.background
    background.width = love.graphics.getWidth() / background.image:getWidth()
    background.height = love.graphics.getHeight() / background.image:getHeight()
    background.marge = 32

    -- Ball
    ball = {}
    ball.image = sprites.ball
    ball.size = 50
    ball.speed = 200
    ball.x = love.graphics.getWidth() / 2
    ball.y = love.graphics.getHeight() / 2

    -- Player
    player1 = {}
    player2 = {}
    player1.score = 0
    player1.location = love.graphics.getWidth() / 2
    player1.padSize = 100
    player1.speed = 600
    player2.score = 0
    
end

function love.update(dt)

    if love.keyboard.isDown("left") then
        player1.location = player1.location - player1.speed * dt
    end
    if love.keyboard.isDown("right") then
        player1.location = player1.location + player1.speed * dt
    end

    if player1.location < 0 + background.marge/2 + player1.padSize/2 then
        player1.location = 0 + background.marge/2 + player1.padSize/2
    end
    if player1.location > love.graphics.getWidth() - background.marge/2 - player1.padSize/2 then
        player1.location = love.graphics.getWidth() - background.marge/2 - player1.padSize/2
    end

    ball.x = ball.x - ball.speed * dt
    if ball.x < 0 + ball.size / 2 then
        ball.x = 0 + ball.size / 2 
    end
    if ball.x > love.graphics.getWidth() - ball.size / 2 then 
        ball.x = love.graphics.getWidth() - ball.size / 2
    end

    print(ball.x)
end

function love.draw()
    -- Background
    love.graphics.draw(background.image, 0, 0, nil, background.width, background.height)
    
    -- Scores
    local _score = player1.score .. " : " .. player2.score
    love.graphics.setFont(scoreFont)
    love.graphics.printf(_score, 0, (love.graphics.getHeight()/2)-(scoreFontSize/2), love.graphics.getWidth(), "center")

    -- Player
    love.graphics.rectangle("fill", (player1.location - player1.padSize/2), love.graphics.getHeight()-(background.marge*1.5), player1.padSize, background.marge)

    -- Ball
    love.graphics.draw(ball.image, ball.x, ball.y, nil, nil,nil, ball.size/2)
end

