# Simulated controller class with restful actions
class Playlists
  def initialize
    @db = Db.instance
  end

  def allowed_actions
    %w[new update delete]
  end

  def new(args)
    args['id'] = db.get_playlists_index.to_s
    instance = Playlist.new(args)

    # add to the list if playlist is valid
    table[instance.id] = instance if instance.validate
  end

  # requirements - add a song to a playlist
  def update(args)
    return unless id_present_in_args_is_valid_playlist(args)

    if args['song_ids'].empty?
      log.warn "Unable to update playlist #{args[:id]}, no songs referened"
    else
      table[args['id']].song_ids += args['song_ids']

      # remove playlist if we remove all songs
      table.delete(args['id']) unless table[args['id']].validate
      return true
    end
    false
  end

  def delete(args)
    return unless id_present_in_args_is_valid_playlist(args)

    table.delete(args['id'])
  end

  private

  attr_reader :db

  def id_present_in_args_is_valid_playlist(args)
    log.warn "Unable to locate playlist #{args[:id]} for update action" if table[args['id']].nil?
    !table[args['id']].nil?
  end

  def table
    db.tables['playlists']
  end

  def log
    @log ||= Log.instance
  end
end
