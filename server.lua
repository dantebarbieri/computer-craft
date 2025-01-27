SERVER_MODEM_SIDE = "top" -- side of the modem on the server
LOGS_RECV = 1    -- general purpose logger
CLIENT_RECV = 10 -- all clients receive messages on this channel
SERVER_RECV = 20 -- server receives messages on this channel
EXIT_COMMAND = "exit" -- shared exit command where clients do not respond

local modem = peripheral.wrap(SERVER_MODEM_SIDE)
modem.open(SERVER_RECV)

repeat
    write("Enter the target channel or press enter to broadcast: ")
    local target = tonumber(io.read())
    local channel = target or CLIENT_RECV
    local log = target and "sending to " .. channel or "broadcasting to all clients"
    print(log)
    modem.transmit(LOGS_RECV, SERVER_RECV, log)
    write("Enter a command or type 'exit' to quit: ")
    local command = io.read()
    modem.transmit(channel, SERVER_RECV, command)
    if command ~= EXIT_COMMAND then
        local event, modemSide, senderChannel, replyChannel, message, senderDistance = os.pullEvent("modem_message")
        log = message .. " from " .. replyChannel .. " at distance " .. senderDistance
        print(log)
        modem.transmit(LOGS_RECV, SERVER_RECV, log)
    end
until command == EXIT_COMMAND

modem.close(SERVER_RECV)
