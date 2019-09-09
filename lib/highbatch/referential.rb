class Referential
  EXPECTED_MODELS = %w"users songs playlists"
  attr_accessor :db
  attr_reader :file_path

  def initialize(file_path)
    @db = Db.instance
    @file_path = file_path
  end

  protected
  attr_reader :input # memoized value storage below

  def log
    @log ||= Log.instance
  end

  # metaprograming to DRY out creating object type for each model class
  # Provides extensibility for future model additions
  def constantize(key)
    Object.const_get(key.capitalize)
  end
  
  def constantize_singularize(key)
    Object.const_get(key.capitalize.delete_suffix("s"))
  end 

   # memoized handling of the json file
   def json
    @input ||= JSON.parse File.read(file_path)
  end
end