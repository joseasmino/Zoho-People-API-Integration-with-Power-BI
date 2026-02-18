# Testing & Validation – Zoho People API (Google Colab)

This document captures the validation steps performed before implementing the integration in Power BI.

The objective was to confirm:

- OAuth 2.0 authentication flow
- Regional endpoint correctness (`zoho.in`)
- API permission validation
- JSON response structure
- Data transformation feasibility

---

## Environment

- Google Colab
- Python
- requests library
- pandas library

---

## Import Libraries

```python
import requests
import pandas as pd
```

---

## Exchange Grant Token for Refresh Token

```python
url = "https://accounts.zoho.in/oauth/v2/token"
params = {
    "grant_type": "authorization_code",
    "client_id": "",
    "client_secret": "",
    "code": ""
}

response = requests.post(url, params=params)
print(response.json())
```

---

## Generate Access Token Using Refresh Token

```python
token_url = "https://accounts.zoho.in/oauth/v2/token"
token_params = {
    "refresh_token": "",
    "client_id": "",
    "client_secret": "",
    "grant_type": "refresh_token"
}

access_token = requests.post(token_url, params=token_params).json().get("access_token")
access_token
```

---

## Fetch Employee Records

```python
api_url = "https://people.zoho.in/people/api/forms/P_Employee/getRecords"

headers = {"Authorization": f"Zoho-oauthtoken {access_token}"}
api_params = {"start": 1, "limit": 100}

response = requests.get(api_url, headers=headers, params=api_params)
data = response.json()

print(data)
```

---

## Convert JSON Response to DataFrame

```python
results = data.get("response", {}).get("result", [])

records = []

for item in results:
    for key, value in item.items():
        if isinstance(value, list):
            records.extend(value)

df = pd.DataFrame(records)

df.head()
```

---




