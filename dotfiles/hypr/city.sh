#!/bin/bash

# Make the API request to ip-api.com
response=$(curl -s "http://ip-api.com/json")

# Parse the city and region from the JSON response
city=$(echo $response | jq -r '.city')
region=$(echo $response | jq -r '.region')

# Check if the city is in the Delhi region
if [[ "$region" == "DL" ]]; then
    city="New Delhi"
fi

# Capitalize the city name
city=$(echo "$city" | awk '{print toupper($0)}')

# Output the capitalized city name
echo "$city"

