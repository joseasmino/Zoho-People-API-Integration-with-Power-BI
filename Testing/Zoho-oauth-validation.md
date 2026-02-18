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

## Cell 1 – Import Libraries

```python
import requests
import pandas as pd


url = "https://accounts.zoho.in/oauth/v2/token"
params = {
    "grant_type": "authorization_code",
    "client_id": "",
    "client_secret": "",
    "code": ""
}

response = requests.post(url, params=params)
print(response.json())
