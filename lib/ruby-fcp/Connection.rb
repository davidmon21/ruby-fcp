require 'ruby-fcp/PacketFactory'
require 'ruby-fcp/Packet'

class Connection
    attr_accessor \
      :Version,
      :Client,
      :Host,
      :Port,
      :Version,
      :ConnectionIdentifier,
      :Socket,
      :Packets,
      :RawResponses
    def initialize(client, host="127.0.0.1", port=9481, version="2.0")
      @Packets = []
      @RawResponses = []
      @Client = client
      @Host = host
      @Port = port
      @Socket = TCPSocket.new @Host, @Port
      @ConnectionIdentifier = self.send_recv PacketFactory::ClientHello.new(@Client).ConnectionIdentifier
    end
    def grab_packet
      rawResponse = @Socket.recvmsg
      @RawResponses.append rawResponse
      @Packets.append Packet.new(rawResponse[0])
    end
    def send(pack)
      @Socket.write(pack.compile)
    end
    def recv
      rawResponse = @Socket.recvmsg
      @RawResponses.append rawResponse
      packet = Packet.new(rawResponse[0])
      @Packets.append packet
      return packet
    end
    def send_recv(pack)
      self.send pack 
      return self.recv
    end
end