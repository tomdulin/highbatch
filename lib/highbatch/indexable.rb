class Indexable
  attr_reader :id

  def initialize(args)
    args = defaults.merge(args)
    @id = args['id']
  end

  def validate
    true
  end

  def to_hash
    hash = { 'id' => id }
    instance_variables.each do |var|
      hash[to_human(var)] = instance_variable_get var
    end
    hash
  end

  protected

  def log
    @log ||= Log.instance
  end

  private

  # convert symbol /w @ to human readable string
  # see https://stackoverflow.com/questions/3614389/what-is-the-easiest-way-to-remove-the-first-character-from-a-string
  def to_human(val)
    val.to_s[1..-1] # most performant way to remove first char from string
  end

  def defaults
    { 'id' => '' }
  end
end
