require 'spec_helper'

feature "User views the index page" do
  scenario "user sees the correct title" do
    visit '/'

    expect(page).to have_content "Meetups in Space"
    # expect(page).to have_content "Sign out"
  end
end

feature "User views the show page" do
  scenario "user sees the correct title" do
    visit '/'
    # click_link "Save Command"

    expect(page).to have_content "Aardvdark"
  end
end


# feature "User can log in" do
#   scenario "user sees they are signed in as their username in top bar" do
#     visit '/'
#     # user = User.find(2)
#     # binding.pry
#     # set_current_user(user)
#     # click_on 'Sign in'
#     # expect(page).to have_content "Signed in as"
#   end
# end
