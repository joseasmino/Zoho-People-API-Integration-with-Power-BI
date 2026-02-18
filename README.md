# Zoho People API Integration with Power BI

## 🎯 Objective

Connect to Zoho People with Power BI using a secure OAuth 2.0 authentication method and enable automated cloud refresh in Power BI Service.

---

## 🧩 What Was Achieved

We successfully:

- Established OAuth 2.0 authentication with Zoho People
- Generated and managed Access Tokens dynamically
- Retrieved employee data via API
- Implemented the solution using Power Query (M)
- Enabled compatibility with Power BI Service cloud refresh
- Avoided on-premises gateway dependency

---

## 🛠 Approach

### 1️⃣ Validation Phase

Before implementing in Power BI, the API and authentication flow were validated in a controlled test environment to ensure:

- Correct regional endpoint selection (`zoho.in`)
- Proper OAuth token generation
- Correct API permissions
- Understanding of the JSON response structure

Once validated, the logic was implemented directly in Power BI.

---

### 2️⃣ Authentication (OAuth 2.0)

Zoho People requires:

- Client ID  
- Client Secret  
- Refresh Token  

Power BI dynamically:

1. Generates an Access Token using the Refresh Token  
2. Passes the Access Token in the Authorization header  
3. Retrieves employee records securely  

---

### 3️⃣ Power BI Implementation

The solution was built using:

- `Web.Contents()` with POST request for token generation
- Static root URL with `RelativePath`
- Query parameters passed using `Query` record
- Anonymous authentication (handled internally in M)

This ensures:

- Scheduled refresh compatibility
- No Dynamic Data Source errors
- Secure cloud-based execution

---

## 📊 Data Retrieval

API Endpoint Used:
https://people.zoho.in/people/api/forms/P_Employee/getRecords
