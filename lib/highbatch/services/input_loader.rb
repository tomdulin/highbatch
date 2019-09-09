# Single Responsibility - load mixtape json file into db cache
class InputLoader < Referential
  def initialize(file_path)
    super(file_path)
  end

  # loop through inputs and convert to cache model
  def call
    log.info 'loading ..'
    validate_keys_are_correct

    # maintain key ordering
    json.keys.each { |entity| db.tables[entity] ||= {} } # JIT initialization

    # load in this order to validate playlists (users and songs need to be loaded first)
    EXPECTED_MODELS.each { |entity| insert_values_into_db_cache(entity, json[entity]) }
  end

  private

  # ensure that the keys listed in the mixtape.json file are what we expect
  def validate_keys_are_correct
    raise InvalidAttributeError, "#{EXPECTED_MODELS - json.keys} were not found in the mixtape.json file" unless (EXPECTED_MODELS - json.keys).empty?
  end

  def insert_values_into_db_cache(entity_string, values)
    entity = constantize_singularize(entity_string) # calculate object reference
    values.each do |instance_values|
      instance = entity.new(instance_values) # generate instance of object
      if instance.validate # only add if input is valid
        db.tables[entity_string][instance.id] = instance
        db.send("set_#{entity_string}_index", instance.id)
      end
    end
  end
end
