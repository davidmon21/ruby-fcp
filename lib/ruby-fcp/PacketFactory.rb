module PacketFactory
  module Ext
    def attr_accessor_with_content_set(*names)
      attr_reader *names
      names.each do |name|
        define_method :"#{name}=" do |v|
          instance_variable_set(:"@#{name}", v)
          instance_exec(name,v) {|name,v| @Content["#{name}"]= v}
        end
      end
    end
  end

  class Packet
    #Base Packet super class
    extend Ext
    attr_reader :Packet
    def initialize(type)
      @Content={}
      @Type=type
      @Line="\n"
    end
    def compile
      @Packet = @Content.map{|k,v| "#{k}=#{v}"}.join(@Line)
      "#{@Type}#{@Line}#{@Packet}#{@Line}EndMessage#{@Line}"
    end
  end
  class ClientHello < Packet
    #Used to Intialize connection session
    attr_accessor_with_content_set :Name,:ExpectedVersion
    def initialize(name,expectedVersion="2.0")
      super("ClientHello")
      self.Name = name
      self.ExpectedVersion = expectedVersion
    end
  end
  class TestDDARequest < Packet
    attr_accessor_with_content_set \
      :Directory,
      :WantReadDirectory,
      :WantWriteDirectory
    def initialize(dir, read=true,write=false)
      super("TestDDARequest")
      self.Directory=dir
      self.WantReadDirectory="true" if read
      self.WantWriteDirectory="true" if write
    end
  end
  class TestDDAResponse < Packet
    attr_accessor_with_content_set :Directory, :ReadContent
    def initialize(directory,readcontent=nil)
      super("TestDDAResponse")
      self.Directory=directory
      self.ReadContent=readcontent if readcontent != nil
    end
  end
  class ClientGet < Packet
    attr_accessor_with_content_set \
      :IgnoreDS,
      :DSonly,
      :URI,
      :Identifier,
      :Verbosity,
      :MaxSize,
      :MaxTempSize,
      :MaxRetries,
      :PriorityClass,
      :Persistence,
      :ClientToken,
      :Global,
      :ReturnType,
      :BinaryBlob,
      :FilterData,
      :AllowedMIMETypes,
      :Filename,
      :TempFilename,
      :RealTimeFlag
    def initialize(uri,id)
      super("ClientGet")
      self.URI = uri
      self.Identifier = id
    end
    def InitialMetaDataLength=(length)
      @InitialMetadataDataLength = length
      @Content["InitialMetadata.DataLength"] = length
    end
  end
  class ClientPut < Packet
    attr_accessor_with_content_set \
      :URI,
      :Identifier,
      :Verbosity,
      :MaxRetries,
      :PriorityClass,
      :GetCHKOnly,
      :Global,
      :DontCompress,
      :Codecs,
      :ClientToken,
      :Persistence,
      :TargetFilename,
      :EarlyEncode,
      :UploadFrom,
      :DataLength,
      :FileName,
      :TargetURI,
      :FileHash,
      :BinaryBlob,
      :ForkOnCacheable,
      :ExtraInsertsSingleBlock,
      :ExtraInsertsSplitfileHeaderBlock,
      :CompatibilityMode,
      :LocalRequestOnly,
      :OverrideSplitfileCryptoKey,
      :RealTimeFlag,
      :MetadataThreshold
    def initialize(uri,identifier,forkOnCachable=true)
      super("ClientPut")
      self.URI = uri
      self.Identifier = identifier
      self.ForkOnCachable=forkOnCacable
    end
    def MetadataContentType=(type)
      @MetadataContentType=type
      @Current["Metadata.ContentType"]=type
    end
    def compile(direct=false, data)
      unless direct
        super()
      else
        @Content["DataLength"]=data.length
        @Packet = @Content.map{|k,v| "#{k}=#{v}"}.join(@Line)
        "#{@Type}#{@Line}#{@Packet}#{@Line}Data#{@Line}#{data}"
      end
    end
  end
  class Void
    def initialize
      @Packet="Void\nEndMessage\n"
    end
    def compile
      @Packet
    end
  end
  class Disconnect
    def initialize
      @Packet="Disconnect EndMessage\n"
    end
    def compile
      @Packet
    end
  end
end
