class InvalidAttributeError < StandardError
  def initialize(msg="An invalid attribute has been detected")
    super
  end
end