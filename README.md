<!-- RUNNING PROJECTS: -->

1. Install and run the apk
2. open the apps and user will be directly routed to main page

Main page (All countries):
3. In the main page user will see list of countries from the API, here user also see the detail such as total cases and total deaths
4. In the main page user can sort the data based on cases, click on "sort by lowest case" and the data will be automatically sorted starting from countries with the lowest case of covid-19
5. User can undo the sort by lowest case by clicking "sort by alphabetic order"
6. To see more detail on covid-19, user can tap country card to directly view the country detail

Detail Page (Country Detail):
7. Click on country list card and see the detail page
8. User can view total population and historical graph of the selected country
9. To view more detailed data on historical graph, user can click the extension tile and view the graph of death caused by covid-19 from yesterday and 2 days ago
10. Click back to go to the main page again


<!-- BUILDING PROJECTS: -->
1. install required package (refer to pubspec.yaml line 49 - 58)
2. create first design of Application UI to better understand what we are going to do
3. Create Bloc folder to process the apps logic

Main page (All countries):
4. import required package (refer to get_all_country.dart line 1 - 5)
5. Create enum SelectedCountryList to define event that will trigger Bloc logic
6. Create All Country class that is an extension of Bloc package
7. Create StreamController of input and output. Input is for triggering the logic and Output is to give response for User Interface purpose
8. Create void function of mapEventToState to route the algorithm for getting the data based on user preference.

9. Main page view (All countries - not sorted):
    (logic)
    a) Access http link of "https://covid19-graphql.netlify.app/"
    b) Create HiveStore for flutter to store data from GraphQL response
    c) Create GraphQL query 
    d) Get the query response and store it to variable
    e) Add the variable to the stream and send it to the UI

    (interface)
    f) Wrap home in the main.dart with Bloc Provider widget
    g) Initiate blocProvider at the beginning before Scaffold to access the Bloc
    h) initstate the condition where data is not sorted by lowest case
    i) Create StreamBuilder widget to access data steam from Bloc, select stream, and builder.
    j) Create conditions in the builder when the response of query has data we will return user widget, else we return progress indicator until data is retreived
    k) Access the data and showcase it to the user.

10. Main page view (All countries - sorted by lowest cases):
    (logic)
    a) Get the stored data from previous condition when countries is not sorted
    b) Sort the data by the lowest case
    c) get the query response and store it to variable
    d) add the variable to the stream and send it to the UI

    (interface)
    e) User tap "sort by lowest case" button, it will trigger the sorting logic in the Bloc and store the selected country in the shared preference
    f) The list of country in the main page will be automatically changed and sorted by the lowest cases

11. Detail page (Country Detail)
    (logic)
    a) Create CountryDetail class, it is not an extension of Bloc
    b) Create StreamController of input and output. Input is for triggering the logic and Output is to give response for User Interface purpose
    c) Create function that will listen to the input stream and process the logic
    d) Accessed the SharedPreferences to get the selected country from User
    e) access http link of "https://covid19-graphql.netlify.app/"
    f) Create HiveStore for flutter to store data from GraphQL response
    g) Create GraphQL query 
    h) get the query response and store it to variable
    i) Repeat and chain the process from point d - h to get the data of the selected country from 2 days ago
    j) Add the variable to the stream and send it to the UI
    k) Create dispose function to terminate the listener

    (interface)
    l) Initstate the condition and trigger the data logic
    m) Create StreamBuilder widget to access data steam from Bloc, select stream, and builder.
    n) Create conditions in the builder when the response of query has data we will return user widget, else we return progress indicator until data is retreived
    o) Access the data and showcase it to the user.
    p) Press back arrow in the app bar to return to main page

    