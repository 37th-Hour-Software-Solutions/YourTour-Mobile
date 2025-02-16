# API Documentation

The following is the API documentation for the backend of the app. All content-type headers should be set to `application/json`. Endpoints with (Authenticated) require a valid access token in the Authorization header (Authorization: <accessToken>). 

If the API call is successful, the response will be a JSON object with an `error` field set to `false` and a `data` field containing the data returned by the API call. If the API call is unsuccessful, the response will be a JSON object with an `error` field set to `true` and a `data.message` field containing the error message.

## Endpoints

### /auth (auth.js)

- `POST /auth/register` (No authentication required)
```json
{
    "email": "test@test.com",
    "username": "test",
    "password": "password",
    "name": "John Doe",
    "phone": "+11234567890",
    "homestate": "NY",
    "interests": ["travel", "food", "history"]
}

{
    "error": false,
    "data": {
        "message": "User registered successfully"   
    }
}
```

- `POST /auth/login` (No authentication required)
```json
{
    "email": "test@test.com",
    "password": "password"
}

{
    "error": false,
    "data": {
        "accessToken": "1234567890",
        "refreshToken": "1234567890"
    }
}
```

- `POST /auth/refresh` (No authentication required)
```json
{
    "refreshToken": "1234567890"
}

{
    "error": false,
    "data": {
        "accessToken": "1234567890"
    }
}
```



### /profile (profile.js)

- `GET /profile` (Authenticated)
```json
{
    "error": false,
    "data": {
        "id": "1234567890",
        "username": "test",
        "name": "John Doe",
        "phone": "+11234567890",
        "homestate": "NY",
        "interests": [
            {
                "name": "travel",
            }
        ],
        "gems": [
            {
                "city": "New York",
                "state": "NY",
                "description": "The Big Apple"
            }
        ],
        "badges": [
            {
                "name": "traveler",
                "description": "Traveled to 10 countries",
                "static_image_url": "https://example.com/traveler.png"
            }
        ],
        "gemsFound": 1,
        "badgesFound": 1
    }
}
```

- `POST /profile/update` (Authenticated)
```json
{
    "email": "new@example.com",
    "username": "NewUsername",
    "oldPassword": "OldPassword123!",
    "password": "NewPassword123!",
    "name": "Jane Doe",
    "phone": "+11234567890",
    "homestate": "CA",
    "interests": ["technology", "innovation", "science"]
}
```

```json
{
    "error": false,
    "data": {
        "message": "Profile updated successfully"
    }
}
```

### /navigation (navigation.js)

- `GET /navigation/geocode/:query` (Authenticated)

```
Query: "100 Main St, Nashville, TN"

{
    "error": false,
    "data": {
        "latitude": 36.1627,
        "longitude": -86.7816,
        "formatted_address": "100 Main St, Nashville, TN"
    }
}
```

- `GET /navigation/geocode/reverse/:latitude/:longitude` (Authenticated)

```
Latitude: 36.1627
Longitude: -86.7816

{
    "error": false,
    "data": {
        "road": "100 Main St",
        "city": "Nashville",
        "state": "Tennessee",
        "country": "United States"
    }
}
```

- `GET /navigation/geocode/reverse/poi/:latitude/:longitude` (Authenticated)

```
Latitude: 36.1627
Longitude: -86.7816

{
    "error": false,
    "data": {
        "city": "Nashville",
        "state": "Tennessee",
        "isGem": true,
        "isBadge": true
    }
}
```


- `GET /navigation/directions/:origin/:destination` (Authenticated)

```
Origin: "36.1627,-86.7816"
Destination: "36.1627,-86.7816"

{
    "error": false,
    "data": {
        "tripId": 1,
        "instructions": [],
        "distance": 100,
        "duration": 100,
        "prettySteps": []
    }
}
```

- `GET /navigation/directions/preview/:origin/:destination` (Authenticated)

```
Origin: "36.1627,-86.7816"
Destination: "36.1627,-86.7816"

{
    "error": false,
    "data": {
        "instructions": [],
        "distance": 100,
        "duration": 100,
        "prettySteps": []
    }
}
```



### /generate (generate.js)

- `GET /generate/trip/:tripId/city/:city/:state` (Authenticated)

```
Trip ID: 1
City: "Nashville"
State: "Tennessee"

{
    "error": false,
    "data": {
        "tripId": 1,
        "city": "Nashville",
        "state": "Tennessee",
        "facts": []
    }
}
```