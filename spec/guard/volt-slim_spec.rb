require 'spec_helper'

describe Guard::VoltSlim do
  it 'has a version number' do
    expect(Guard::VoltSlimVersion).not_to be nil
  end

  it 'show test convert' do
    html = Guard::VoltSlim::Compiler.new('spec/files/test.slim').build
    puts html
    # expect(true).to eq(true)
  end

  it 'convert templates' do
    html = Guard::VoltSlim::Compiler.new('spec/files/template.slim').build
    expect(html).to eq(<<SBR)
<:Template>
Body
SBR
  end

  it 'convert template use' do
    html = Guard::VoltSlim::Compiler.new('spec/files/template_use.slim').build
    expect(html).to eq(<<SBR.gsub(/\n\z/, ''))
<:template>
Body
</:template>
SBR
  end

end
