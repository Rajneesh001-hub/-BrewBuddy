#!/bin/bash

# BrewBuddy - Run Script
# Run: chmod +x run.sh && ./run.sh

echo "🚀 Starting BrewBuddy App..."
echo "📱 App will open at: http://127.0.0.1:8080"
echo ""

flutter run -d chrome --web-port=8080
