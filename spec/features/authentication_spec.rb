require 'rails_helper'

feature "Authentication Flow", js: true do
  scenario "Exploring site without authenticating" do
    visit '/'
    expect(page).to have_content('Connect with Instagram')
    expect(page).not_to have_css('.alert')
    expect(page).not_to have_selector('img')
    expect(page).not_to have_css('.username')
    expect(page).not_to have_content('Log out')

    visit '/media'
    expect(page).to have_current_path('/')
    expect(page).to have_content('You must connect with Instagram')
  end

  # No good way to automate this scenario because no way to programmatically
  #   revoke app access and ensure authorize dialogue appears.
  # Maybe use Selenium to go to Instagram account page and de-authorize
  #   in before block?
  # scenario "Connecting but not authorizing" do
  #   visit '/'
  #   click_link 'Connect with Instagram'
  #   fill_in('Username', with: 'simplepicsdotcom')
  #   fill_in('Password', with: ENV['INSTAGRAM_TEST_USER_PASSWORD'])
  #   click_button 'Log in'
  #   expect(page).to have_content('Simplepics is requesting')
  #   click_button 'Cancel'
  #   expect(page).to have_current_path('/')
  #   expect(page).to have_content('Authentication with Instagram failed')
  #   expect(page).not_to have_content('Log out')
  # end

  scenario "Connecting, exploring, logging out" do
    connect_to_instagram
    expect(page).to have_current_path('/media')
    expect(page).to have_content('Log out')
    expect(page).to have_css('.thumb')
    expect(page).to have_css('nav .username')
    expect(page).to have_css('nav img')

    visit '/'
    expect(page).to have_css('nav .username')
    expect(page).to have_css('nav img')
    expect(page).to have_content('Log out')

    click_link 'Log out'
    expect(page).to have_current_path('/')
    expect(page).not_to have_css('nav .username')
    expect(page).not_to have_css('nav img')
    expect(page).not_to have_content('Log out')

    visit '/media'
    expect(page).to have_current_path('/')
    expect(page).to have_content('You must connect with Instagram')
  end

end
