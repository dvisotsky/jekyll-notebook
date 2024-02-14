# convert markdown to jekyll note
# Usage: ./converter.sh <markdown file>

SOURCE_DIR=~/Documents/notebook/Lessons
TARGET_DIR=./_notes/Public

# Loop through each Markdown file in the source directory and its subdirectories
find "$SOURCE_DIR" -type f -name '*.md' -print0 | while IFS= read -r -d '' file; do
    # Get the filename without the extension
    filename=$(basename "$file" .md)

    # Touch the file in the target directory
    touch "$TARGET_DIR/$filename.md"

    # Insert front matter
    {
        echo "---"
        echo "layout: note"
        echo "title: $filename"
        echo "date: $(date)"
        echo "---"
    } >"$TARGET_DIR/$filename.md"

    # Append the content of the file
    cat "$file" >>"$TARGET_DIR/$filename.md"
done