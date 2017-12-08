require 'test_helper'

class LocaleHandlingTest < ActionDispatch::IntegrationTest
  test "should redirect to url parameter language" do
    host! 'animalrights.test'
    get events_path, params: { change_language: I18n.available_locales[-1], test: "foo" }
    assert_redirected_to host: "#{I18n.available_locales[-1]}.animalrights.test",
      params: { test: "foo" }
  end

  test "should redirect to Accept-Language" do
    # Test base domain with non-default language header
    host! 'animalrights.test'
    get root_path, headers: { 'Accept-Language' => I18n.available_locales[-1]}
    assert_redirected_to host: "#{I18n.available_locales[-1]}.animalrights.test"
    follow_redirect!
    assert_select "html[lang=#{I18n.available_locales[-1]}]"

    # Test base domain with german language header again
    host! 'animalrights.test'
    get root_path, headers: { 'Accept-Language' => I18n.available_locales[-1] }
    assert_select "html[lang=#{I18n.default_locale}]"
  end

  test "should use default locale on unavailable Accept-Language" do
    host! 'animalrights.test'
    get root_path, headers: {'Accept-Language' => 'gazorpazorp'}
    assert_select "html[lang=#{I18n.default_locale}]"
  end

  test "should redirect to base domain and serve default locale" do
    host! "#{I18n.default_locale}.animalrights.test"
    get root_path, headers: {'Accept-Language' => I18n.available_locales[-1]}
    assert_redirected_to host: 'animalrights.test'
    follow_redirect!
    assert_select "html[lang=#{I18n.default_locale}]"
  end

  test "should redirect to base domain and then to available language" do
    host! "gazorpazorp.animalrights.test"
    get root_path, headers: {'Accept-Language' => I18n.available_locales[-1]}
    assert_redirected_to host: 'animalrights.test'
    get headers['location'], headers: {'Accept-Language' => I18n.available_locales[-1]}
    assert_redirected_to host: "#{I18n.available_locales[-1]}.animalrights.test"
    follow_redirect!
    assert_select "html[lang=#{I18n.available_locales[-1]}]"
  end
end
