
require "spec_helper"

RSpec.describe CLI do
  let!(:def_mix_path){File.join(__dir__,  'samples', 'mixtape1.json')}
  let!(:def_changes_path){File.join(__dir__,  'samples', 'change_file1.json')}
  let!(:def_out_path){File.join(__dir__,  'samples', 'outfile1.json')}

  before do
    File.delete(def_out_path) if File.exist?(def_out_path)
    db = Db.instance
    db.refresh
  end

  it "can be called " do
    cli = CLI.new(true)
    expect(cli.call(args)).to be true
    expect(File.exist?(def_out_path)).to be true
  end

  def args
    {
      input: def_mix_path,
      changes: def_changes_path,
      output: def_out_path,
    }
  end
end
