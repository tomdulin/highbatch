class Db
  include Singleton
  attr_accessor :tables,   # rudimentary representation of models for short term data storage
                :indexes   # array of integers - maintains referential integrity of id's
  # 0 tracks user, 1 tracks songs, 2 tracks playlists

  def defaults
    @tables ||= {}
    @indexes ||= [0, 0, 0]
  end

  def refresh
    @tables = {}
    @indexes = [0, 0, 0]
  end

  # sets next index value - used when added a new instance
  def get_users_index
    set_index((indexes[0] + 1).to_s, 0)
  end

  def get_playlists_index
    set_index((indexes[1] + 1).to_s, 1)
  end

  def get_songs_index
    set_index((indexes[2] + 1).to_s, 2)
  end

  # tracks max index when loading input file
  def set_users_index(idx)
    set_index(idx, 0)
   end

  def set_playlists_index(idx)
    set_index(idx, 1)
  end

  def set_songs_index(idx)
    set_index(idx, 2)
  end

  attr_accessor :user_index, :playlists_index, :songs_index

  # tracks max index (updates if new index is larger than given index)
  # returns max index + 1 when string value = 0
  def set_index(string_value, type_index)
    integer_index = parse_int(string_value)
    @indexes[type_index] = integer_index if integer_index > @indexes[type_index]
    @indexes[type_index]
 end

  # safely parses integer or returns 0 when value is invalid
  def parse_int(string_value)
    string_value.nil? || string_value !~ /^\d+$/ ? 0 : Integer(string_value)
  end
end
