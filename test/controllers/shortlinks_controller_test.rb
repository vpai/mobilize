require 'test_helper'

class ShortlinksControllerTest < ActionDispatch::IntegrationTest

  ###
  ###  Test creating link.
  ###

  test "create short link" do
    post "/links/new", params: { original_url: "https://www.google.com" }

    assert_response :success
    assert_equal JSON.parse(@response.body)["link"], "http://www.example.com/8662db8f"
  end

  test "create short link (existing)" do
    post "/links/new", params: { original_url: "https://www.google.com" }
    post "/links/new", params: { original_url: "https://www.google.com" }

    assert_response :success
    assert_equal JSON.parse(@response.body)["link"], "http://www.example.com/8662db8f"
  end

  test "create custom short link" do
    post "/links/new", params: { original_url: "https://www.facebook.com", custom_short_url: 'my-custom-link' }

    assert_response :success
    assert_equal JSON.parse(@response.body)["link"], "http://www.example.com/my-custom-link"
  end

  test "create custom short link (sad path)" do
    post "/links/new", params: { original_url: "https://www.google.com" }
    post "/links/new", params: { original_url: "https://www.facebook.com", custom_short_url: '8662db8f' }

    assert_response :internal_server_error
    assert_equal JSON.parse(@response.body)["error"], "url_taken"
  end

  ###
  ###  Test redirection.
  ###

  test "redirect (happy path)" do
    post "/links/new", params: { original_url: "https://www.google.com" }
    get '/8662db8f'

    assert_redirected_to 'https://www.google.com'
  end

  test "redirect (sad path)" do
    get '/does-not-exist'

    assert_response :not_found
  end

  ###
  ###  Test stats.
  ###

  test "stats returns hash with correct keys" do
    post "/links/new", params: { original_url: "https://www.google.com" }
    get '/stats/8662db8f'

    assert_equal JSON.parse(@response.body).keys, ["created_at", "total_visits", "hit_counts"]
  end

  test "stats (sad path)" do
    get '/stats/does-not-exist'

    assert_response :not_found
  end
end
