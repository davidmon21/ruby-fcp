require 'ruby-fcp'
require 'async'

uri = "USK@940RYvj1-aowEHGsb5HeMTigq8gnV14pbKNsIvUO~-0,FdTbR3gIz21QNfDtnK~MiWgAf2kfwHe-cpyJXuLHdOE,AQACAAE/publish/3/jsite-select-project.png"
client = Client.new "HelloAClientYoBee"
puts client.ConnectionIdentifier

saveloc = '/tmp/jsite-select-project.png'
puts client.dda_test('/tmp/')

getPacket = PacketFactory::ClientGet.new uri, client.ConnectionIdentifier
getPacket.ReturnType= 'disk'
getPacket.Filename= saveloc 
puts (client.Connection.send_recv getPacket).Raw
