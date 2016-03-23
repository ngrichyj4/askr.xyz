require 'rails_helper'

describe Option do
  let(:option) { build :option }
  it "exposes the text field in it's to_s method" do
    option.text = 'some string'
    expect(option.to_s).to eq 'some string'
  end

  it "belongs to poll" do
    expect(option).to belong_to(:poll)
  end
end
