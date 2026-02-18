# Architecture Notes – Zoho People API Integration

## 1. Authentication Design (OAuth 2.0)

Zoho People requires OAuth 2.0 authentication.

The implementation uses:

- Client ID
- Client Secret
- Refresh Token
- Dynamically generated Access Token

Power Query (M) performs a POST request to:
https://accounts.zoho.in/oauth/v2/token


The refresh token is exchanged for a short-lived access token during every refresh cycle.

This ensures:

- No manual token management
- Cloud refresh compatibility
- Secure credential flow

---

## 2. POST-Based Token Generation

The token request is implemented using:

- `Web.Contents`
- `Content` parameter (POST body)
- `#"Content-Type"` header

Credentials are passed inside the request body instead of URL concatenation.

Reason:

- Prevents HTTP 400 errors
- Avoids Dynamic Data Source issues
- Required for Power BI Service refresh stability

---

## 3. Static Root URL Pattern

To enable Scheduled Refresh in Power BI Service:

- Root URL remains static
- `RelativePath` is used for endpoint routing
- Query parameters passed using `Query` record

Example structure:
BaseUrl = "https://people.zoho.in/"
RelativePath = "people/api/forms/P_Employee/getRecords"


This prevents the "Dynamic Data Source" error in the Service.

---

## 4. Authorization Handling

Authentication type in Power BI is set to:


Reason:

- OAuth token is injected manually in the `Authorization` header.
- Selecting Basic or Web API would conflict with manual header injection.

Header format:
Authorization = "Zoho-oauthtoken " & AccessToken


---

## 5. Privacy Level Configuration

Both Zoho endpoints must be set to:


Reason:

Power Query combines:

- Token generation endpoint
- Data retrieval endpoint

If privacy levels differ, the Formula.Firewall error occurs.

---

## 6. JSON Transformation Strategy

Zoho API response structure:

- Nested under `response`
- Dynamic ID keys
- Employee records inside list

Transformation logic:

1. Access `response[result]`
2. Extract dynamic key using `Record.FieldNames`
3. Convert list to table
4. Expand records dynamically

This ensures compatibility even if ID keys change.

---

## 7. Current Scope

- Single API call
- Retrieves first 100 records
- Pagination intentionally excluded (Phase 1 validation)

---

## 8. Future Enhancements

- Implement pagination using `List.Generate`
- Introduce incremental refresh
- Parameterize credentials
- Move to Server-Based OAuth client
- Secure secret storage for production

---

## Summary

This implementation:

- Uses OAuth 2.0 securely
- Supports Power BI Service cloud refresh
- Avoids gateway dependency
- Maintains static URL compliance
- Handles dynamic JSON structures

Designed for scalability and production hardening.

