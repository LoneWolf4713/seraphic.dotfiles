#!/bin/bash

# Function to fetch "feels like" temperature for a given city ID
get_feels_like_temperature() {
    city_id=$1
    api_key="9f815d625b1fa077b8d8f70bdfb0c205"  # Your actual API key from OpenWeatherMap
    url="http://api.openweathermap.org/data/2.5/weather?id=${city_id}&appid=${api_key}&units=metric"
    
    # Fetch data from API
    response=$(curl -s "$url")
    
    # Parse JSON response and extract "feels like" temperature
    feels_like_temperature=$(echo "$response" | jq -r '.main.feels_like')
    
    # Round off the temperature to the nearest integer
    rounded_temperature=$(printf "%.0f" "$feels_like_temperature")
    
    echo $rounded_temperature
}

# Main function
main() {
    city_id=1260788  # Bangalore city ID
    feels_like_temperature=$(get_feels_like_temperature "$city_id")
    
    if [ -n "$feels_like_temperature" ]; then
        echo "${feels_like_temperature}°C"
    else
        echo "0°C"
    fi
}

# Execute main function
main

