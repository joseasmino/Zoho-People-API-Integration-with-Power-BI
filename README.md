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

---

Current implementation retrieves the first 100 employee records (pagination intentionally excluded for Phase 1 validation).

---

## ⚙️ Power BI Configuration

### Power BI Desktop
- Authentication Type: **Anonymous**
- Privacy Level: **Organizational**

### Power BI Service
- Set both Zoho endpoints to:
  - Authentication: Anonymous
  - Privacy Level: Organizational
- Scheduled Refresh enabled

---

## 🚧 Issues Resolved During Implementation

- Region mismatch errors
- Incorrect API endpoint path
- Role-based API restrictions
- HTTP 400 errors from URL concatenation
- Privacy firewall conflicts
- Empty dataset handling

All issues were resolved and documented during development.

---

## ✅ Current Status

- OAuth flow fully operational
- Employee data successfully retrieved
- Cloud refresh compatible
- No gateway required
- Production-ready architecture foundation established

---

## 🔐 Security Considerations

- Credentials should not be stored in source control
- Refresh Tokens should be rotated periodically
- Secure storage recommended for production deployment

---

## 🚀 Next Enhancements (Optional)

- Implement pagination for large datasets
- Add incremental refresh
- Parameterize credentials
- Convert to Server-Based OAuth for production

---

**Status:** Successfully implemented and validated.

