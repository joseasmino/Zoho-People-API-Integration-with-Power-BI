let
    // 1. Setup
    BaseUrl = "https://people.zoho.in/", 
    ClientID = "",
    ClientSecret = "",
    RefreshToken = "",

    // 2. Token Generation
    TokenResponse = Json.Document(Web.Contents("https://accounts.zoho.in/oauth/v2/token", [
        Content = Text.ToBinary(""),
        Query = [
            refresh_token = RefreshToken,
            client_id = ClientID,
            client_secret = ClientSecret,
            grant_type = "refresh_token"
        ]
    ])),
    AccessToken = TokenResponse[access_token],

    // 3. Function to Fetch One Page
    FetchPage = (startIndex as number) =>
        let
            Response = Json.Document(Web.Contents(BaseUrl, [
                RelativePath = "people/api/forms/P_Employee/getRecords",
                Query = [
                    sIndex = Text.From(startIndex),
                    limit = "200"
                ],
                Headers = [Authorization = "Zoho-oauthtoken " & AccessToken],
                Timeout = #duration(0,0,4,0)
            ])),
            Result = try Response[response][result] otherwise null
        in
            Result,

    // 4. Pagination Loop
    PagedData = List.Generate(
        () => [Index = 1, Data = FetchPage(1)],
        each [Data] <> null and List.Count([Data]) > 0,
        each [Index = [Index] + 200, Data = FetchPage([Index] + 200)],
        each [Data]
    ),

    // 5. Combine All Pages
    CombinedList = List.Combine(PagedData),

    // 6. Convert to Table
    TableFromList = Table.FromList(CombinedList, Splitter.SplitByNothing(), null, null, ExtraValues.Error),

    // Extract dynamic ID key
    ExtractData = Table.AddColumn(
        TableFromList,
        "EmployeeList",
        each Record.Field([Column1], Record.FieldNames([Column1]){0})
    ),

    ExpandedList = Table.ExpandListColumn(ExtractData, "EmployeeList"),

    FinalTable = Table.ExpandRecordColumn(
        ExpandedList,
        "EmployeeList",
        Record.FieldNames(ExpandedList{0}[EmployeeList])
    )

in
    FinalTable
