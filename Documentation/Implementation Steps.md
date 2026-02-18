# Implementation Steps – Zoho People API Integration

This document outlines the step-by-step process used to integrate Zoho People API with Power BI.

---

## Step 1 – Generate OAuth Credentials

1. Log in to Zoho API Console.
2. Select **Self Client**.
3. Add required scope: ZohoPeople.forms.READ
4. Generate a **Grant Token**.
5. Exchange the Grant Token for a **Refresh Token**.
6. Save:
   - Client ID
   - Client Secret
   - Refresh Token

These credentials are required for Power BI integration.

---

## Step 2 – API Validation (Testing Phase)

Before implementing in Power BI, the OAuth flow and API endpoint were validated in a controlled testing environment (Google Colab).

### Objectives of Testing

- Confirm correct regional endpoint (`zoho.in`)
- Validate OAuth 2.0 token generation
- Verify API permissions
- Inspect JSON response structure
- Confirm employee records retrieval

### Validation Flow

1. Exchange Grant Token for Refresh Token.
2. Generate Access Token using Refresh Token.
3. Call Employee API endpoint: https://people.zoho.in/people/api/forms/P_Employee/getRecords
4. Confirm that valid employee records are returned.

Once confirmed, the logic was translated into Power Query (M).

---

## Step 3 – Build Power BI Token Logic

In Power BI Desktop:

1. Go to **Get Data → Blank Query**
2. Open **Advanced Editor**
3. Implement POST request to generate Access Token:

- Use `Web.Contents`
- Pass credentials using `Content`
- Use `#"Content-Type"` header
- Avoid URL concatenation

This ensures:

- Secure credential handling
- Cloud refresh compatibility
- No HTTP 400 errors

---

## Step 4 – Retrieve Employee Data

Using the generated Access Token:

- Keep base URL static
- Use `RelativePath`
- Pass `start` and `limit` using `Query`
- Inject Authorization header manually

Example structure:
BaseUrl = "https://people.zoho.in/"

RelativePath = "people/api/forms/P_Employee/getRecords"

---

## Step 5 – Transform JSON to Table

Zoho returns nested JSON with dynamic ID keys.

Transformation approach:

1. Access `response[result]`
2. Extract dynamic key using `Record.FieldNames`
3. Convert list to table
4. Expand record fields dynamically

This ensures flexibility even if record IDs change.

---

## Step 6 – Configure Power BI Credentials

In Power BI Desktop:

- Authentication Type: **Anonymous**
- Privacy Level: **Organizational**

After publishing to Power BI Service:

1. Go to **Semantic Model Settings**
2. Edit Credentials for both Zoho endpoints
3. Set:
   - Authentication: Anonymous
   - Privacy Level: Organizational

Enable Scheduled Refresh.

---

## Step 7 – Validation

Confirm:

- Dataset refresh completes successfully
- No Dynamic Data Source errors
- No Formula.Firewall errors
- Employee data loads correctly

---

## Current Scope

- Single API request
- First 100 employee records
- Pagination intentionally excluded (Phase 1 validation)

---

## Optional Enhancements

- Implement pagination using `List.Generate`
- Add incremental refresh
- Parameterize credentials
- Secure secret storage
- Production hardening

---

## Outcome

Zoho People successfully integrated with Power BI using OAuth 2.0.

Cloud refresh enabled.

No gateway required.



