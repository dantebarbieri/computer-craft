SERVER_MODEM_SIDE = "top" -- side of the modem on the server
CLIENT_RECV = 10 -- all clients receive messages on this channel
SERVER_RECV = 20 -- server receives messages on this channel
EXIT_COMMAND = "exit" -- shared exit command where clients do not respond

local modem = peripheral.wrap(SERVER_MODEM_SIDE)
modem.open(SERVER_RECV)

repeat
    local command = io.read()
    modem.transmit(CLIENT_RECV, SERVER_RECV, command)
    if command ~= EXIT_COMMAND then
        local event, modemSide, senderChannel, replyChannel, message, senderDistance = os.pullEvent("modem_message")
        print(message .. " from " .. replyChannel .. " at distance " .. senderDistance)
    end
until command == EXIT_COMMAND

modem.close(SERVER_RECV)
