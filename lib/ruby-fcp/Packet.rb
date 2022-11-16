class Packet
  attr_accessor :Raw,:Content,:Type,:IsError, :Data
  def initialize(packetData)
    @Raw = packetData
    lines = packetData.split("\n")
    @Type=lines[0]
    @Content={} 
    for line in lines[1..-1]
      if line  == "Data"
        @Data = packetData.bytes[-(@DataLength.to_i)..-1]
        break
      end
      unless line =~ /EndMessage/
        self.process_line  line
      end
    end
  end
  def process_line(line)
    var,value = line.split("=")
    subVars = var.split('.')
    if subVars.length > 1
      reversed = subVars.reverse()
      temp = value
      for item in reversed[0..-2]
        temp = { item => temp }
      end
      var = reversed[-1].strip
      if instance_variable_defined?("@#{var}")
        instance_variable_set("@#{var}",instance_variable_get("@#{reversed[-1].strip}").append(temp) )
      else
        instance_variable_set("@#{var}", [temp])
        define_singleton_method(var) do 
          instance_variable_get("@#{var}")
        end
      end
    else
      var = var.strip
      @Content[var]=value
      if value != nil
        instance_variable_set("@#{var}", value.strip)
        define_singleton_method(var) do 
          instance_variable_get("@#{var}")
        end
      end
    end
  end
end
