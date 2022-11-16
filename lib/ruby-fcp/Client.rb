require 'ruby-fcp'
require 'async'

class Client 
    attr_accessor :ConnectionIdentifier, :Communicator
    def initialize(name, host='127.0.0.1', port=9481, version="2.0")
        @Communicator = Communicator.new name, version, host, port
        @ConnectionIdentifier = @Communicator.ConnectionIdentifier
    end
    def dda_test(directory, read=true,write=true, return_type='disk')
        response = @Communicator.send_recv PacketFactory::TestDDARequest.new(directory,read,write)
        content = nil
        if write 
            File.open(response.WriteFilename, 'w') do |file|
                file.write response.ContentToWrite
            end
        end
        if read
            content = File.read(response.ReadFilename)
        end
        response = PacketFactory::TestDDAResponse.new directory, content
        final = @Communicator.send_recv response 
        return { :write => (final.WriteDirectoryAllowed == "true"), :read => (final.ReadDirectoryAllowed == "true") }
    end
    def simple_direct_get(uri,saveloc,progresshook=method(:puts))
        getPacket = PacketFactory::ClientGet.new uri, @ConnectionIdentifier
        getPacket.ReturnType= 'direct'
        response = @Communicator.send_recv getPacket 
        until response.Data != nil
            progresshook.call response 
            response = @Communicator.recv 
        end
        File.open(saveloc, 'wb') do |output| 
            response.Data.each do |byte|
                output.print byte.chr 
            end
        end 
    end
end