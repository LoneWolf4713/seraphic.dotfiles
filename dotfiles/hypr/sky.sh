#!/bin/bash

# Set your API key and city ID
API_KEY="9f815d625b1fa077b8d8f70bdfb0c205"
CITY_ID="1260788"

# Make the API request to OpenWeather
response=$(curl -s "http://api.openweathermap.org/data/2.5/weather?id=${CITY_ID}&appid=${API_KEY}")

# Parse the sky condition from the JSON response and capitalize it
sky_condition=$(echo $response | jq -r '.weather[0].description' | awk '{print toupper($0)}')

# Output the capitalized sky condition
echo "$sky_condition"

