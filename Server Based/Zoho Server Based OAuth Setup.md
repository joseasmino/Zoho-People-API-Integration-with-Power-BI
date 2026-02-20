# Zoho Server-Based Application Client Setup Guide

## Overview

This document explains how to create and configure a **Server-Based Application Client** in Zoho API Console for secure OAuth 2.0 authentication.

This setup is required for:

- Power BI integrations
- Backend ETL pipelines
- Automated API data extraction
- Enterprise-grade Zoho integrations

---

# Architecture Overview

OAuth Flow Used:

1. Generate Authorization Code (one-time)
2. Exchange Authorization Code → Refresh Token
3. Use Refresh Token → Generate Access Token (hourly)
4. Use Access Token → Call Zoho API

---

# Step 1 — Create Server-Based Client

## 1. Go to Zoho API Console

Open:

https://api-console.zoho.in

(Use your correct region if different)

---

## 2. Click “Add Client”

Select:

Server-based Applications

---

## 3. Fill Application Details

| Field | Value |
|-------|-------|
| Client Name | PowerBI_API_Integration |
| Homepage URL | https://localhost |
| Authorized Redirect URI | https://localhost |

Click **Create**.

---

## 4. Save Credentials

Zoho will generate:

- Client ID
- Client Secret

Store these securely.

---

# Step 2 — Generate Authorization Code

Open browser and run:

```text
https://accounts.zoho.in/oauth/v2/auth?
scope=ZohoPeople.forms.ALL&
client_id=YOUR_CLIENT_ID&
response_type=code&
access_type=offline&
redirect_uri=https://localhost
```

Login and approve access.

Zoho will redirect to:

```text
https://localhost/?code=1000.xxxxxxxxx
```

The page will fail — this is expected.

Copy the value of:

```text
code
```

---

# Step 3 — Exchange Code for Refresh Token

Run immediately (authorization code expires quickly):

```python
import requests

url = "https://accounts.zoho.in/oauth/v2/token"

data = {
    "grant_type": "authorization_code",
    "client_id": "YOUR_CLIENT_ID",
    "client_secret": "YOUR_CLIENT_SECRET",
    "redirect_uri": "https://localhost",
    "code": "PASTE_AUTH_CODE_HERE"
}

response = requests.post(url, data=data)
print(response.json())
```

Successful response:

```json
{
  "access_token": "...",
  "refresh_token": "...",
  "expires_in": 3600
}
```

Store the `refresh_token` securely.

---

# Step 4 — Generate Access Token (Using Refresh Token)

Use this whenever needed:

```python
import requests

token_url = "https://accounts.zoho.in/oauth/v2/token"

data = {
    "refresh_token": "YOUR_REFRESH_TOKEN",
    "client_id": "YOUR_CLIENT_ID",
    "client_secret": "YOUR_CLIENT_SECRET",
    "grant_type": "refresh_token"
}

response = requests.post(token_url, data=data)
access_token = response.json().get("access_token")

print(access_token)
```

Access tokens are valid for 1 hour.

---

# Step 5 — Call Zoho API

Example:

```python
import requests

url = "https://people.zoho.in/people/api/forms/P_Employee/getRecords"

headers = {
    "Authorization": f"Zoho-oauthtoken {access_token}"
}

params = {
    "sIndex": 1,
    "limit": 200
}

response = requests.get(url, headers=headers, params=params)
print(response.json())
```

---

# Important Notes

## Authorization Code
- Works only once
- Expires in a few minutes
- Must match redirect URI exactly

## Redirect URI
Must exactly match:

```
https://localhost
```

No trailing slash. No http. No port changes.

---

# Security Best Practices

Never commit:
- Client Secret
- Refresh Token
- Access Token

Use:
- Environment variables
- Secure vault
- `.gitignore`

---

# When to Use Server-Based Client

Use when:

- Integration is long-term
- Used in production dashboards
- Multiple reports depend on it
- Governance and audit tracking required

Avoid using Self Client in enterprise environments.

---

# Summary

Server-Based Application Client provides:

- Secure OAuth 2.0 flow
- Long-term refresh capability
- Enterprise-grade authentication
- Scalable integration architecture

This setup ensures production-ready integration with Zoho APIs.

---
