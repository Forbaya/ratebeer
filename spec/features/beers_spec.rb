require 'rails_helper'

describe "Beer" do
  let!(:user) { FactoryGirl.create(:user) }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
    FactoryGirl.create :brewery, name:"Panimo"
    FactoryGirl.create :style
  end

  it "can be added with a valid name" do
    visit new_beer_path
    fill_in('beer_name', with:'Bisse')
    select("Lager", from:'beer[style_id]')

    expect {
      click_button "Create Beer"
    }.to change { Beer.count }.from(0).to(1)
  end

  it "can not be added with an empty name" do
    visit new_beer_path
    click_button "Create Beer"

    expect(Beer.count).to be(0)
  end
end
