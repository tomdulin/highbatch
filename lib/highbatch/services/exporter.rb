class Exporter < Referential
  def initialize(file_path)
    super(file_path)
  end

  def call
    log.info 'exporting new file..'
    output_file.write(JSON.pretty_generate(tables_to_hash))
    output_file.close
  end

  private

  def output_file
    @json ||= File.open(file_path, 'w')
  end

  # work through all of the tables converting each to a hash
  def tables_to_hash
    output = {}
    db.tables.keys.each do |entity|
      output[entity] = []
      db.tables[entity].each do |key, _values|
        output[entity] << db.tables[entity][key].to_hash
      end
    end
    output
  end
end
