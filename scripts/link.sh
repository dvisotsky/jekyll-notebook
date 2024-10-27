#!/bin/bash

# Function to generate or update index.md
generate_index() {
    local dir="$1"
    
    # Define the index file path
    local index_file="$dir/index.md"

    # Create or truncate index.md file
    echo "# Index of $(basename "$dir")" > "$index_file"
    echo "" >> "$index_file"

    # Loop over each item in the directory
    for item in "$dir"/*; do
        # Skip index.md itself
        if [[ "$item" == "$index_file" ]]; then
            continue
        fi

        # If the item is a directory, recursively call the function
        if [[ -d "$item" ]]; then
            local subdir_name=$(basename "$item")
            echo "- [${subdir_name}](./${subdir_name}/index.md)" >> "$index_file"
            generate_index "$item"
        elif [[ -f "$item" && "$item" == *.md ]]; then
            local file_name=$(basename "$item")
            echo "- [${file_name}](./${file_name})" >> "$index_file"
            
            # Prepend a 'back' link to the Markdown file
            local temp_file=$(mktemp)
            echo -e "[Back](./index.md)\n" > "$temp_file"
            cat "$item" >> "$temp_file"
            mv "$temp_file" "$item"
        fi
    done

    # Add a "back" link to the index.md in the parent directory
    if [[ "$dir" != "$(pwd)" ]]; then
        local temp_index_file=$(mktemp)
        echo "- [Back to parent index](../index.md)" > "$temp_index_file"
        cat "$index_file" >> "$temp_index_file"
        mv "$temp_index_file" "$index_file"
    fi
    if [[ "$dir" != "$(pwd)" ]]; then
        echo "- [Back to parent index](../index.md)" >> "$index_file"
    fi
}

# Start the process from the current directory
generate_index "$(pwd)"