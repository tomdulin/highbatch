# frozen_string_literal: true

class CLI
  # verbose allows us to moc out logging when running tests
  def initialize(verbose = true)
    @db = Db.instance
    @log = Log.instance
    db.defaults
    log.defaults(verbose)
  end

  def call(args)
    parse_args(args)
    input_loader.call
    process_changes.call
    output_file.call
    log.info 'Cheers!'
    return true
  rescue InvalidAttributeError => e
    log.error(e.message)
    return false
  end

  private

  attr_accessor :db
  attr_reader :mix_path, :changes_path, :out_path, :log

  def parse_args(args) # (mix_path, changes_path, out_path)
    return false unless all_valid_input_files(args)

    @mix_path = args[:input]
    @changes_path = args[:changes]
    @out_path = args[:output]
  end

  def all_valid_input_files(args)
    success = true
    args.each do |key, value|
      next if key == :output
      unless File.exist?(value)
        log.error("Unable to find #{key} file :: #{value}")
        success = false
      end
    end
    success
  end

  def input_loader
    @input_loader_mem ||= InputLoader.new(mix_path)
  end

  def process_changes
    @process_changes_mem ||= ProcessChanges.new(changes_path)
  end

  def output_file
    @output_file_mem ||= Exporter.new(out_path)
  end
end
