LOGS_RECV = 1                        -- general purpose logger

local modem = nil
local peripherals = peripheral.getNames()
for name = 1, #peripherals, 1 do
    if (peripheral.getType(peripherals[name]) == "modem") then
        modem = peripheral.wrap(peripherals[name])
        break
    end
end

if(modem == nil) then
    error("Error, this program requires a Modem!")
end

modem.open(LOGS_RECV)

while true do
    local event, modemSide, senderChannel, replyChannel, message, senderDistance = os.pullEvent("modem_message")
    local log = replyChannel .. ": " .. message .. " (" .. senderDistance .. " m)"
    local color = math.floor(replyChannel / 10)
    term.setTextColor(color)
    print(log)
end

modem.close(LOGS_RECV)
