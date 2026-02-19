/*
Zoho People API Integration - Power BI
OAuth 2.0 Dynamic Token Generation
Cloud Compatible Implementation
Do NOT store real credentials in production.
*/

let
    // 1. Setup (Keep your existing working credentials)
    BaseUrl = "https://people.zoho.in/", 
    ClientID = "",
    ClientSecret = "",
    RefreshToken = "",

    // 2. Token Generation (POST)
    TokenResponse = Json.Document(Web.Contents("https://accounts.zoho.in/oauth/v2/token", [
        Content = Text.ToBinary(""),
        Query = [refresh_token=RefreshToken, client_id=ClientID, client_secret=ClientSecret, grant_type="refresh_token"]
    ])),
    AccessToken = TokenResponse[access_token],

    // 3. Data Retrieval (Fetches all 100 records in the first page)
    Source = Json.Document(Web.Contents(BaseUrl, [
        RelativePath = "people/api/forms/P_Employee/getRecords",
        Query = [start = "1", limit = "100"], 
        Headers = [Authorization = "Zoho-oauthtoken " & AccessToken],
        Timeout = #duration(0, 0, 4, 0) // Max 4-minute Service timeout [3, 4]
    ])),

    // 4. Transformation Logic (Handles all rows in 'result')
    ResultList = Source[response][result],
    TableFromList = Table.FromList(ResultList, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    
    // Extract data from the dynamic ID key for EVERY row [2, 5]
    ExtractData = Table.AddColumn(TableFromList, "EmployeeList", each Record.Field([Column1], Record.FieldNames([Column1]){0})),
    ExpandedList = Table.ExpandListColumn(ExtractData, "EmployeeList"),
    
    // Expand employee records into columns
    FinalTable = Table.ExpandRecordColumn(ExpandedList, "EmployeeList", Record.FieldNames(ExpandedList{0}[EmployeeList]))
in
    FinalTable
