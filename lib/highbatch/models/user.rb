class User < Indexable
  attr_reader :name

  def initialize(args)
    @name = args['name']
    super(args)
  end

  def validate
    raise InvalidAttributeError, "User entry contains invalid or missing id: #{name}" if id == '0'

    true
  end
end
