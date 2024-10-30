import pytest
TEST_URL = "http://test.com"


def test_health(client):
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"api": True, "database": True}


def test_home_page(client):
    response = client.get("/")
    assert response.status_code == 200
    data = response.context
    assert data is not None, "Context is missing in the response."


def test_generate_short_url(client):
    response = client.post("/generate/", data={"url": TEST_URL})
    assert response.status_code == 200
    data = response.context
    assert data is not None, "Context is missing in the response."
    assert "short_url" in data
    assert data["short_url"].original_url == TEST_URL
    assert data["short_url"].url


@pytest.fixture(scope="session")
def short_url(client):
    response = client.get("/fetchall/")
    return response.context["short_urls"]


def test_generate_duplicate_short_url(client):
    response = client.post("/generate/", data={"url": TEST_URL})
    assert response.status_code == 200
    data = response.context
    assert data is not None, "Context is missing in the response."
    assert data["error_message"] == f"{TEST_URL} has already been generated"


def test_search_original_url(client, short_url):
    response = client.get(
        f"/search/{short_url[0].url}")
    assert response.status_code == 200
    data = response.context
    assert data is not None, "Context is missing in the response."
    assert data["original_url"].original_url == TEST_URL


def test_search_nonexisting_original_url(client):
    response = client.get(
        f"/search/http://tinyurl.com/test")
    assert response.status_code == 200
    data = response.context
    assert data is not None, "Context is missing in the response."
    assert data["error_message"] == "No original URL found for the given short URL"


def test_fetch_short_urls(client):
    response = client.get("/fetchall/")
    assert response.status_code == 200
    data = response.context
    assert data is not None, "Context is missing in the response."
    assert len(data["short_urls"]) == 1
    assert data["short_urls"][0].original_url == TEST_URL


def test_delete_short_url(client, short_url):
    response = client.delete(f"/delete/{short_url[0].url}")
    assert response.status_code == 200
    response = client.get("/fetchall/")
    data = response.context
    assert len(data["short_urls"]) == 0
