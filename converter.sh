# convert markdown to jekyll note
# Usage: ./converter.sh <markdown file>

SOURCE_DIR=~/Documents/notebook/Lessons
TARGET_DIR=./_notes/Public

# Loop through each Markdown file in the source directory and its subdirectories
find "$SOURCE_DIR" -type f -name '*.md' -print0 | while IFS= read -r -d '' file; do
    # Get the filename without the extension
    filename=$(basename "$file" .md)

    #check if the file is a directory
    if [ -d "$file" ]; then
        echo "File $filename is a directory"
        continue
    fi

    # check if the file is already in the target directory
    # if [ -f "$TARGET_DIR/$filename.md" ]; then
        # echo "File $filename.md already exists in the target directory"
        # continue
    # fi

    # Touch the file in the target directory
    touch "$TARGET_DIR/$filename.md"

    # Insert front matter
    {
        echo "---"
        echo "feed: show"
        echo "title: $filename"
        # set date based on the file's last modified date
        echo "date: $(date -r "$file" "+%Y-%m-%d %H:%M:%S %z")"
        echo "---"
    } >"$TARGET_DIR/$filename.md"

    # Append the content of the file
    cat "$file" >>"$TARGET_DIR/$filename.md"
done