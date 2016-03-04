require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new(id: 1, name:"Oljenkorsi") ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if many are returned by the API, they are shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("Helsinki").and_return(
      [ Place.new(id: 1, name:"William K"),
        Place.new(id: 2, name:"Oljenkorsi"),
        Place.new(id: 3, name:"Kolme Kaisaa") ]
    )
    
    visit places_path
    fill_in('city', with: 'Helsinki')
    click_button "Search"

    expect(page).to have_content "William K"
    expect(page).to have_content "Oljenkorsi"
    expect(page).to have_content "Kolme Kaisaa"
  end

  it "if no places are found, user gets a notification" do
    allow(BeermappingApi).to receive(:places_in).with("Mushroom Kingdom").and_return(
      []
    )

    visit places_path
    fill_in('city', with: 'Mushroom Kingdom')
    click_button "Search"

    expect(page).to have_content "No locations in Mushroom Kingdom"
  end
end
