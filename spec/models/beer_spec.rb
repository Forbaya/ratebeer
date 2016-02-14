require 'rails_helper'

RSpec.describe Beer, type: :model do
  it "is saved with a valid name and style" do
    beer = Beer.create name:"Bisse", style:"Lager"

    expect(beer.valid?).to be(true)
  end

  it "is not saved without a name" do
    beer = Beer.create style:"Lager"

    expect(beer.valid?).to be(false)
  end

  it "is not saved without a style" do
    beer = Beer.create name:"Bisse"

    expect(beer.valid?).to be(false)
  end
end
