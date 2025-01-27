LOGS_RECV = 1                        -- general purpose logger
CLIENT_RECV = 10                     -- all clients receive messages on this channel
MY_RECV = math.random(300, 900) * 10 -- this client receives messages on this channel
EXIT_COMMAND = "exit" -- shared exit command where clients do not respond

local modem = nil
local peripherals = peripheral.getNames()
for name = 1, #peripherals, 1 do
    if (peripheral.getType(peripherals[name]) == "modem") then
        modem = peripheral.wrap(peripherals[name])
        break
    end
end

if (modem == nil) then
    error("Error, this program requires a Modem!")
end

modem.open(CLIENT_RECV)
modem.open(MY_RECV)

modem.transmit(LOGS_RECV, MY_RECV, "client started")

local function refuel()
    if turtle.getFuelLevel() > 0 then
        return
    end

    for i = 1, 16 do -- loop through the slots
        turtle.select(i) -- change to the slot
        if turtle.refuel(0) then -- if it's valid fuel
            turtle.refuel(1)     -- refuel using one
            return
        end
      end
end

repeat
    local event, modemSide, senderChannel, replyChannel, message, senderDistance = os.pullEvent("modem_message")
    local response = "ack: " .. message .. " from " .. replyChannel
    modem.transmit(replyChannel, MY_RECV, response)
    modem.transmit(LOGS_RECV, MY_RECV, response)

    local log = nil
    if message == "forward" then
        refuel()
        log = turtle.forward() and "moved forward" or "could not move forward"
    elseif message == "back" then
        refuel()
        log = turtle.back() and "moved back" or "could not move back"
    elseif message == "up" then
        refuel()
        log = turtle.up() and "moved up" or "could not move up"
    elseif message == "down" then
        refuel()
        log = turtle.down() and "moved down" or "could not move down"
    elseif message == "left" then
        refuel()
        log = turtle.turnLeft() and "turned left" or "could not turn left"
    elseif message == "right" then
        refuel()
        log = turtle.turnRight() and "turned right" or "could not turn right"
    elseif message == "dig" then
        log = turtle.dig() and "dug" or "could not dig"
    end

    if log then
        modem.transmit(LOGS_RECV, MY_RECV, log)
    end

until message == EXIT_COMMAND

modem.transmit(LOGS_RECV, MY_RECV, "client ended")

modem.close(MY_RECV)
modem.close(CLIENT_RECV)
