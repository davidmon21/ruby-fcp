require 'ruby-fcp'
require 'async'

class Client 
    attr_accessor :ConnectionIdentifier, :Communicator
    def initialize(name, host='127.0.0.1', port=9481, version="2.0")
        @Communicator = Communicator.new name, version, host, port
        @ConnectionIdentifier = @Communicator.ConnectionIdentifier
    end
    def dda_test(directory, read=false, write=true, return_type='disk')
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
        return { 
            :write => (defined? final.WriteDirectoryAllowed && final.WriteDirectoryAllowed == "true"), 
            :read => (defined? final.ReadDirectoryAllowed && final.ReadDirectoryAllowed == "true") 
        }
    end
    def simple_direct_get(uri,save_location,progresshook=method(:puts))
        get_packet = PacketFactory::ClientGet.new uri, @ConnectionIdentifier
        get_packet.ReturnType= 'direct'
        response = @Communicator.send_recv get_packet 
        while response.Data == nil
            progresshook.call response 
            response = @Communicator.recv 
        end
        File.open(save_location, 'wb') do |output| 
            response.Data.each do |byte|
                output.print byte.chr 
            end
        end 
    end
    def simple_fs_get(uri,save_location,progresshook=method(:puts))
        if dda_test(File.dirname(save_location))[:write]
            get_packet = PacketFactory::ClientGet.new uri, @ConnectionIdentifier
            get_packet.ReturnType= 'disk'
            get_packet.Filename=save_location
            get_packet.TempFilename=save_location+".tmp"
            response = @Communicator.send_recv get_packet
            until response.Type =~ /GetFailed|DataFound/
                progresshook.call response
                response = @Communicator.recv
            end
            return response.Type == "DataFound" || false 
        end        
    end
end