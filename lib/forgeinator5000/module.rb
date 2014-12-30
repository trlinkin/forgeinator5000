require "rubygems"
require "archive/tar/minitar"
require "net/https"
require "digest"
require "zlib"
require "json"

module Forgeinator5000
  class Module

    def initialize name, version
      @name = name.gsub('/', '-')
      @version = version
      read if ondisk?
    end

    def download
      unless ondisk?
        uri = URI.parse(remote_path)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        request = Net::HTTP::Get.new(uri.request_uri)
        response = http.request(request)
        raise "Non-200 HTTP response received while contacting remote forge API.  Possible invalid request?" unless response.code == '200'
        File.open(disk_path, 'w') do |file|
          file.write response.body
        end
      end
    end

    # Remove the module tarball from disk
    def destroy
      File.delete(disk_path)
    end

    # Read metadata from module
    def read
      gz = Zlib::GzipReader.new(File.open(disk_path, 'rb'))
      reader = Archive::Tar::Minitar::Reader.new gz
      reader.each_entry do |file|
        @metadata = JSON.parse(file.read) if file.full_name.include? 'metadata.json'
      end
      reader.close
      gz.close
      # Add an MD5 of the archive to the metadata hash
      @metadata['file_md5'] = Digest::MD5.file(disk_path).hexdigest 
    end

    # Return metadata value given a key
    def [] q
      @metadata[q]
    end

    # Does the module's tarball exist on disk?
    def ondisk?
      File.exist?(disk_path)
    end

    # Returns the correct local tarball path
    def disk_path
      return "/etc/forgeinator5000/modules/#{@name}-#{@version}.tar.gz"
    end

    # Returns the module's tarball URL from the Forge
    def remote_path
      return "https://forgeapi.puppetlabs.com/v3/files/#{@name}-#{@version}.tar.gz"
    end

    # Returns array of Forgeinator5000::Module instances
    def self.all load=true
      modules = []
      Dir.glob("/etc/forgeinator5000/modules/*.tar.gz").each do |mod|
        base = File.basename(mod, '.tar.gz')
        version = base.split('-')[2]
        name = base.scan(/^\w*-\w*/).flatten[0]
        if load
          modules << Forgeinator5000::Module.new(name, version)
        else
          modules << { 'name' => name, 'version' => version }
        end
      end
      return modules
    end
  end
end
