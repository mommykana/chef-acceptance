require 'spec_helper'

module Page
  class Login < SitePrism::Page
    set_url '/login'
      
    element :login_username_text, '#login-username'
    element :login_password_text, '#login-password'
    element :login_button, 'input.btn.btn-small'
    element :landing_element, 'div.app'

    def login(user_factory)
      load
      login_username_text.set user_factory.username
      login_password_text.set user_factory.password
      login_button.click
      wait_for_landing_element
      return user_factory
    end
  end
end