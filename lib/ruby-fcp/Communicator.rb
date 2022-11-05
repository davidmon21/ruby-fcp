require 'async'
require 'ruby-fcp/Connection'
require 'ruby-fcp/PacketFactory'

class Communicator 
    def initialize(connection)
        @Connection = connection
    end

    def simple_get(url,directory, opts)
    end
end