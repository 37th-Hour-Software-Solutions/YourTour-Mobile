# App Design

## UI Design

- The app is designed for mobile devices (we can safely ignore Desktop and Web).
- The app should follow Apple's Human Interface Guidelines.
- The app should be designed for both light and dark mode. 
- The app should follow clean, modern, and minimalistic design (similar to Apple Maps).
- Design should be consistent across all screens (fonts, colors, input fields, etc.)
- Avoid using default Material styling, use custom styling instead to have a more clean/modern/Apple-like look.

## Screens

- Onboarding Screen (unauthenticated): Showcases the app features in a carousel. Last carousel has "Register" and "Login" buttons.
    - Each carousel has a title, subtitle, and a icon (use Lottie for icon animations)
    - The carousel should be swipeable and show dots at the bottom to indicate which slide the user is on
    - Confetti should explode when the user swipes to the last carousel
    - The "Register" and "Login" buttons should be large and centered at the bottom of the screen

- Login Screen (unauthenticated): Allows users to login with email and password. Should also have a "Forgot Password" button and a "Need an account? Sign up" button.
    - Makes an API call to login and if successful, stores the refresh token and accesss token in secure storage.
    - If the login is successful, the user is redirected to the Home Screen.
    - If the login is unsuccessful, show the error message.

- Register Screen (unauthenticated): Allows users to register with email, username, password, name, phone, homestate, and interests. Should also have a "Already have an account? Sign in" button.
    - Makes an API call to register and if successful, redirects to the login screen.
    - If the registration is unsuccessful, show the error message.

- Home Screen (authenticated): Shows (1) a map which when tapped, redirects to the Navigation Screen. (2) "Discover" section which shows tiles of nearby cities and tapping opens a modal with information about the city.

- Navigation Screen (authenticated): The core of the app. Similar to Apple Maps, the user can pan and zoom the map. The map is centered on the user's current location. There is a search bar at the top which allows the user to search for a city. Upon selecting a location, a modal pops up with information about the upcoming trip (miles, estimated time, etc. and a "Start" button). The "Start" button will make API calls to get the the route.
    - The map should follow the user's current location and update the map as the user moves.
    - Once "Start" is pressed, it should paint the route on the map.
    - Once "Start" is pressed, all other widgets should be hidden. An "End Trip" button should be shown at the bottom of the screen. There should also be a control panel at the bottom which has icons for (1) Mute (2) Directions (3) Free Roam. Mute will mute/unmute the TTS. Directions will show a modal with the directions. Free Roam will allow the user to pan and zoom the map and stop following the user. 
    - Once "Start" is pressed, a recurring background task should be started which will get the user's current location and make an API call to poi to get the closest city and then make an API call to get the facts about the city. Those facts should be then spoken by the TTS. This recurring task should be done every 3 minutes and should be stopped when the user presses "End Trip". Additionally, it should track the previous city and only get the facts when the user has entered a new city.

- History Screen (authenticated): Shows the user's history of trips. Should be a table view with the following columns: (1) Date (2) Start City, State -> End City, State. Upon tapping a row, a modal pops up with a list of all the stops in the trip. Tapping on a stop will show a modal with information about the stop.

- Profile Screen (authenticated): Shows the user's profile information: (1) Username (2) Number of Gems (3) Number of Badges (4) Number of Cities Visited (5) Number of States Visited. Clicking on the gems will show a modal with the user's gems. Clicking on the badges will show a modal with the user's badges. There should also be a cog icon in the top right which opens the Settings Screen.

- Settings Screen (authenticated): Shows the user's information such as email, username, phone, homestate, and interests and allows the user to update their information. There is a "Logout" button at the bottom which logs the user out.

## App Flow

The first ever launch of the app should be the Onboarding Screen. Once the user logs in, we can set a shared preference to indicate that the user has completed the onboarding process. Check this preference to determine whether to show Home or Onboarding Screen.

Screens that are authenticated should have an authentication middleware that checks if the user is authenticated. If the user is not authenticated, the user is redirected to the Login Screen. This middleware should make an API call to the `/auth/verify` endpoint to verify the user's access token. If the access token is invalid, the user is redirected to the Login Screen.



