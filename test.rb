require 'ruby-fcp'
require 'async'

uri = "USK@940RYvj1-aowEHGsb5HeMTigq8gnV14pbKNsIvUO~-0,FdTbR3gIz21QNfDtnK~MiWgAf2kfwHe-cpyJXuLHdOE,AQACAAE/publish/3/jsite-select-project.png"
client = Client.new "HelloAClientYoBee"
puts client.ConnectionIdentifier

saveloc = '/tmp/jsite-select-project.png'
#puts client.dda_test('/tmp/')

getPacket = PacketFactory::ClientGet.new uri, client.ConnectionIdentifier
getPacket.ReturnType= 'direct'
#getPacket.Filename= saveloc 
response = client.Connection.send_recv getPacket
File.open("newimage.png", 'wb') do |output| 
    response.Data.each do |byte|
        output.print byte.chr 
    end
end 
