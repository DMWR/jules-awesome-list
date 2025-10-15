import requests

def get_user_data(user_id):
    """
    A hypothetical function that fetches user data from an API.
    """
    response = requests.get(f"https://api.example.com/users/{user_id}")
    if response.status_code == 200:
        return response.json()
    return None

def test_get_user_data_success(mock_user_api):
    """
    Tests the get_user_data function using the mock_user_api fixture.
    This test does not make a real network call.
    """
    # Call the function that would normally make an API call
    user_data = get_user_data(1)

    # Assert that our function correctly parsed the mocked response
    assert user_data is not None
    assert user_data["name"] == "Jules"
    assert user_data["email"] == "jules.agent@example.com"

    # We can also assert that the mocked API was called correctly
    mock_user_api.assert_called_once_with("https://api.example.com/users/1")