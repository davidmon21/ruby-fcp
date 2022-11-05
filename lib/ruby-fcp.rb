require 'rubygems'
require 'socket'
require 'digest'
require 'base64'

%w[ PacketFactory PacketDock fcp_client communicator utils ].each do |file|
 require "ruby-fcp/#{file}"
end
