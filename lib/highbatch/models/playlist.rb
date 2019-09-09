class Playlist < Indexable
  attr_accessor :user_id, :song_ids
  EXPECTED_ARGS = %w[id user_id song_ids].freeze

  def initialize(args)
    args = defaults.merge(args)
    @user_id = args['user_id']

    unless (EXPECTED_ARGS - args.keys).empty?
      raise InvalidAttributeError, "#{EXPECTED_ARGS - args.keys} were not found in the attributes of playlist"
    end

    # protect against duplicate values and o[1] insert/deletes
    @song_ids = Hash[args['song_ids'].collect { |item| [item, ''] }].keys
    super(args)
  end

  def validate
    log.warn("#{(song_ids - db.tables['songs'].keys)} are invalid song ids for Playlist #{id}") unless all_song_ids_are_valid?
    song_ids = valid_song_ids # throw out any invalid song_ids

    log.warn("Playlist #{id} does not have any songs associated") if song_ids.nil? || song_ids.empty?
    log.warn("Playlist #{id} does not have a valid user_id #{user_id}") unless user_is_valid?

    # requirements state to only allow valid songs - not throw an exception if they are found
    !(song_ids.nil? || song_ids.empty?) && user_is_valid?
  end

  private

  def user_is_valid?
    db.tables['users'].key?(user_id)
  end

  def all_song_ids_are_valid?
    (song_ids - db.tables['songs'].keys).empty?
  end

  # array of selected song_ids that are valid
  def valid_song_ids
    song_ids - (song_ids - db.tables['songs'].keys)
  end

  def defaults
    { 'user' => '', "songs": [] }
  end

  def db
    Db.instance
  end
end
