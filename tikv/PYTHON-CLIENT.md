### Run Python Client
Install python client, it's a wrapper around Rust client.

```bash
pip install tikv-client
```

Run a simple python client:

```python
from tikv_client import RawClient

def connect_db():
    return RawClient.connect(["127.0.0.1:2379"])

def update_db(client):
    client.put(b'foo', b'bar')
    print(client.get(b'foo')) # b'bar'

    client.put(b'foo', b'baz')
    print(client.get(b'foo')) # b'baz

if __name__ == "__main__":
    client = connect_db()
    update_db(client)

```