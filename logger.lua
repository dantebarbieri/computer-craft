LOGS_RECV = 1 -- general purpose logger
SERVER_RECV = 20
CLIENT_MINIMUM = 300
CLIENT_MAXIMUM = 900
CLIENT_GAP = 10
COLOR_MINIMUM = 2
COLOR_MAXIMUM = 14

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

local function replyChannelColor(replyChanel)
    local r = replyChanel / CLIENT_GAP

    if replyChanel < CLIENT_MINIMUM then
        return math.floor(r)
    end

    local u = (r - CLIENT_MINIMUM) / (CLIENT_MAXIMUM - CLIENT_MINIMUM)

    local exponent = COLOR_MINIMUM + (COLOR_MAXIMUM - COLOR_MINIMUM) * u

    return 2^exponent
end

modem.open(LOGS_RECV)

while true do
    local event, modemSide, senderChannel, replyChannel, message, senderDistance = os.pullEvent("modem_message")
    local color = replyChannelColor(replyChannel)
    if replyChannel == SERVER_RECV then
        replyChannel = "S"
    end
    local log = replyChannel .. ": " .. message .. " (" .. senderDistance .. " m)"
    term.setTextColor(color)
    print(log)
end

modem.close(LOGS_RECV)
