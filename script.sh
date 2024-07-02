#!/bin/bash

# Navigate to the Services directory
cd Services

# Loop through each subdirectory in Services
for dir in */ ; do
    # Check if it's a directory
    if [ -d "$dir" ]; then
        # Navigate to the subdirectory
        cd "$dir"
        
        # Create Models, Views, Controllers directories if they don't exist
        mkdir -p Models Views Controllers
        
        # Print a message indicating that the directories have been created
        echo "Created Models, Views, and Controllers in $dir"
        
        # Navigate back to the Services directory
        cd ..
    fi
done

# Print completion message
echo "Setup complete for all microservices."
