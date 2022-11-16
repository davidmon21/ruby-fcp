require 'ruby-fcp/PacketFactory'

class Communicator 
    attr_accessor \
      :Version,
      :Client,
      :Version,
      :ConnectionIdentifier,
      :Packets,
      :RawResponses
    def initialize(client, version="2.0", host="127.0.0.1", port=9481)
        @Packets = []
        @RawResponses = []
        @Host = host
        @Port = port
        @Connection = TCPSocket.new @Host, @Port
        @Client = client 
        @Version = version 
        packet = self.send_recv PacketFactory::ClientHello.new @Client, @Version
        @ConnectionIdentifier = packet.ConnectionIdentifier  
    end
    def grab_packet
        rawResponse = @Connection.recvmsg
        @RawResponses.append rawResponse
        @Packets.append Packet.new(rawResponse[0])
    end
    def send(pack)
        @Connection.write(pack.compile)
    end
    def recv
        rawResponse=@Connection.recvmsg
        packet = Packet.new(rawResponse[0])
        @Packets.append packet
        return packet
    end
    def send_recv(pack)
        self.send pack
        return self.recv
    end
end