#!/bin/bash

# Set your API key and city ID
API_KEY="9f815d625b1fa077b8d8f70bdfb0c205"
CITY_ID="1260788"

# Make the API request to OpenWeather
response=$(curl -s "http://api.openweathermap.org/data/2.5/weather?id=${CITY_ID}&appid=${API_KEY}")

# Parse the humidity from the JSON response
humidity=$(echo $response | jq -r '.main.humidity')

# Output the humidity
echo "${humidity}%"

