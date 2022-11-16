require 'rubygems'
require 'socket'
require 'digest'
require 'base64'

%w[ PacketFactory Packet Client Communicator ].each do |file|
 require "ruby-fcp/#{file}"
end
