```python
all_records = []
start = 1
batch_size = 200

while True:
    params = {"sIndex": start, "limit": batch_size}
    response = requests.get(api_url, headers=headers, params=params)
    response_data = response.json()["response"]

    if response_data.get("status") == 1:
        print(f"API Error: {response_data.get('errors')}")
        break

    page_result = response_data.get("result", [])

    if not page_result:
        break

    current_batch_records = []
    for item_dict in page_result:
        records_from_item = list(item_dict.values())[0]
        current_batch_records.extend(records_from_item)

    all_records.extend(current_batch_records)

    if len(current_batch_records) < batch_size:
        break

    start += batch_size

df = pd.DataFrame(all_records)
df.head()
```
