import pytest

@pytest.fixture
def mock_user_api(mocker):
    """
    A pytest fixture to mock a call to an external user API.
    This simulates a successful API response with sample user data.
    """
    mock_response = {
        "id": 1,
        "name": "Jules",
        "email": "jules.agent@example.com"
    }

    # We use mocker to patch a hypothetical 'requests.get' function
    # that our application might use.
    mock_get = mocker.patch("requests.get")

    # Configure the mock to return a response object with a .json() method
    mock_get.return_value.json.return_value = mock_response
    mock_get.return_value.status_code = 200

    return mock_get