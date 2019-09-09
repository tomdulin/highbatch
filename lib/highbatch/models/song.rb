class Song < Indexable
  attr_reader :artist, :title

  def initialize(args)
    @artist = args['artist']
    @title  = args['title']
    super(args)
  end
end
