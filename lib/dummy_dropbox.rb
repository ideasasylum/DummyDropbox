require 'mime/types'
require 'mini_magick'

class DummyDropbox
  @@root_path = File.expand_path( "#{File.dirname(__FILE__)}/../test/fixtures/dropbox" )
  
  def self.root_path=(path)
    @@root_path = path
  end
  
  def self.root_path
    @@root_path
  end
end

module Dropbox
  class Session
    def initialize(oauth_key, oauth_secret, options={})
      @ssl = false
      @consumer = OpenStruct.new( :key => "dummy key consumer" )
      @request_token = "dummy request token"
    end
    
    def authorize_url(*args)
      return 'dummy url'
    end
    
    def authorize(options={})
      return true
    end
    
    def authorized?
      return true
    end
    
    def serialize
      return 'dummy serial'
    end
    
    def self.deserialize(data)
      return Dropbox::Session.new( 'dummy_key', 'dummy_secret' )
    end
    
    #################
    # API methods
    #################
    
    def download(path, options={})
      File.read( "#{Dropbox.files_root_path}/#{path}" )
    end
    
    def thumbnail(path, options={})
      image = MiniMagick::Image.open "#{Dropbox.files_root_path}/#{path}"
      image.resize("100x100")
      image.to_blob
    end
    
    def create_folder(path, options={})
      FileUtils.mkdir( "#{Dropbox.files_root_path}/#{path}" )
      
      return self.metadata( path )
    end
    
    # TODO: the original gem method allow a lot of types for 'local_path' parameter
    # this dummy version only allows a file_path
    def upload(local_file_path, remote_folder_path, options={})
      FileUtils.cp( local_file_path, "#{Dropbox.files_root_path}/#{remote_folder_path}/" )
      
      return self.metadata( "#{remote_folder_path}/#{File.basename(local_file_path)}" )
    end
    
    def metadata(path, options={})
      mime_types = MIME::Types.type_for "#{Dropbox.files_root_path}#{path}"
      is_graphic = mime_types[0] and mime_types[0].media_type == 'image'
      
      response = <<-RESPONSE
        {
          "thumb_exists": "#{is_graphic}",
          "bytes": "#{File.size( "#{Dropbox.files_root_path}/#{path}" )}",
          "modified": "Tue, 04 Nov 2008 02:52:28 +0000",
          "path": "#{path}",
          "is_dir": #{File.directory?( "#{Dropbox.files_root_path}/#{path}" )},
          "size": "566.0KB",
          "root": "dropbox",
          "icon": "page_white_acrobat",
          "mime_type": "#{mime_types[0].to_s}"
        }
      RESPONSE
      return parse_metadata(JSON.parse(response).symbolize_keys_recursively).to_struct_recursively
    end

    ElementStruct = Struct.new(:path, :icon, :'directory?', 
    :path, :thumb_exists, :modified, :bytes, :is_dir, 
    :size, :revision, :mime_type)
    class ElementStruct
        def to_s
            "#{self[:path]}"
        end
    end

    
    def list(path, options={})
      result = []
      
      Dir["#{Dropbox.files_root_path}/#{path}/**"].each do |full_path|
        element_path = full_path.gsub( "#{Dropbox.files_root_path}/", '' )
        
        mime_types = MIME::Types.type_for full_path
        is_graphic = mime_types[0] and mime_types[0].media_type == 'image'
        
        element = {:icon => 'folder',
            :path => element_path,
            :thumb_exists => is_graphic,
            :modified => File.mtime(full_path),
            :revision => 1,
            :bytes => File.size(full_path),
            :is_dir => File.directory?(full_path),
            :size => "#{File.size(full_path)} bytes",
            :mime_type => mime_types[0].to_s
        }
        
        result << element.to_struct
      end
      
      return result
    end
    
    def account
      response = <<-RESPONSE
      {
          "country": "",
          "display_name": "John Q. User",
          "quota_info": {
              "shared": 37378890,
              "quota": 62277025792,
              "normal": 263758550
          },
          "uid": "174"
      }
      RESPONSE
      
      return JSON.parse(response).symbolize_keys_recursively.to_struct_recursively
    end
  end

  def self.files_root_path
    return DummyDropbox::root_path
  end
end
