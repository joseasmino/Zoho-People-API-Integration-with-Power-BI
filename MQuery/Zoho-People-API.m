/*
Zoho People API Integration - Power BI
OAuth 2.0 Dynamic Token Generation
Cloud Compatible Implementation
Do NOT store real credentials in production.
*/

let
    // 1. Setup (Keep your existing working credentials)
    BaseUrl = "https://people.zoho.in/", 
    ClientID = "1000.F9PNFSYETZFN0PFQ5JMQ2QE724D51X",
    ClientSecret = "dddbd5418ebdcd66f2300902ad5386e327568e0018",
    RefreshToken = "1000.f1c159cd05aae90be6292a7de5595da9.1ae00deba6826d5c23988a0c749fc25b",

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
