require 'ruby-fcp'
require 'async'

class Client 
    attr_accessor :ConnectionIdentifier, :Connection
    def initialize(name, host='127.0.0.1', port=9481, version="2.0")
        @Connection = Connection.new name, host, port, version
        @ConnectionIdentifier = @Connection.ConnectionIdentifier
    end
    def dda_test(directory, read=true,write=true, return_type='disk')
        response = @Connection.send_recv PacketFactory::TestDDARequest.new(directory,read,write)
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
        final = @Connection.send_recv response 
        return { :write => (final.WriteDirectoryAllowed == "true"), :read => (final.ReadDirectoryAllowed == "true") }
    end
end