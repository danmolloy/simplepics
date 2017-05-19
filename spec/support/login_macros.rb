module LoginMacros
  def connect_to_instagram
    visit '/'
    click_link 'Connect with Instagram'
    fill_in('Username', with: 'simplepicsdotcom')
    fill_in('Password', with: ENV['INSTAGRAM_TEST_USER_PASSWORD'])
    click_button 'Log in'
    if page.has_content?('Simplepics is requesting')
      click_button 'Authorize'
    end
  end
end
