require 'rails_helper'

include Helpers

describe "User" do
  before :each do
    FactoryGirl.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")
      
      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      visit signin_path
      fill_in('username', with:'Pekka')
      fill_in('password', with:'wrong')
      click_button('Log in')

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end
  end

  describe "favorite style and brewery" do
    it "should be correct with two ratings" do
      user = FactoryGirl.create :user, username:"vilu"
      brewery1 = FactoryGirl.create :brewery, name:"Asd"
      brewery2 = FactoryGirl.create :brewery
      lager = FactoryGirl.create :style
      ipa = FactoryGirl.create :style, name: "IPA"
      beer1 = FactoryGirl.create :beer, name:"IPA", style:lager, brewery:brewery2
      beer2 = FactoryGirl.create :beer, name:"Koff", style:ipa, brewery:brewery1
      rating1 = FactoryGirl.create :rating, beer:beer1, user:user
      rating2 = FactoryGirl.create :rating2, beer:beer2, user:user

      visit user_path(user)

      expect(page).to have_content("favorite style: IPA")
      expect(page).to have_content("favorite brewery: Asd")
    end
  end

  describe "with ratings" do
    it "can see their own ratings on their user page" do
      brewery = FactoryGirl.create :brewery, name:"Koff"
      beer = FactoryGirl.create :beer, name:"Karhu", brewery:brewery
      user = FactoryGirl.create :user, username:"vilu"
      rating = FactoryGirl.create :rating, beer:beer, user:user
      
      visit user_path(user)

      expect(page).to have_content("has made 1 rating")
      expect(page).to have_content("Karhu")
    end

    it "can delete their own rating" do
      user = FactoryGirl.create :user, username:"vilu"
      sign_in(username:"vilu", password:"Foobar1")

      beer = FactoryGirl.create(:beer)
      rating = FactoryGirl.create(:rating, beer:beer, user:user)

      visit user_path(user)
      page.first(:link, "delete").click
      expect(user.ratings.count).to eq(0)
    end
  end
  
  it "is added to the system, when signed up with good credentials" do
    visit signup_path
    fill_in('user_username', with:'Brian')
    fill_in('user_password', with:'Secret55')
    fill_in('user_password_confirmation', with:'Secret55')

    expect {
      click_button('Create User')
    }.to change { User.count }.by(1)
  end
end
