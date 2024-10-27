from fastapi.testclient import TestClient

from url_shortener.main import app

client = TestClient(app)


def test_health():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"api": True, "database": True}
