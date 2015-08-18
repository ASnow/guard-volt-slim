require 'spec_helper'

describe Guard::VoltSlim do
  it 'has a version number' do
    expect(Guard::VoltSlimVersion).not_to be nil
  end


  it 'runs convert' do
    runner = Guard::VoltSlim.new
    runner.run_on_additions ['spec/files/test.slim']
    # puts Guard::VoltSlim::ERBConverter.new({pretty: true, use_html_safe: false}).call(File.read('spec/files/test.slim'))
    expect(false).to eq(true)
  end

end
