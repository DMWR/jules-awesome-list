#!/bin/bash
set -e

# --- Helper function to display a developer joke ---
get_dev_joke() {
    # Check for dependencies
    if ! command -v curl &> /dev/null || ! command -v jq &> /dev/null; then
        echo "Skipping developer joke: 'curl' or 'jq' not found."
        return
    fi

    echo ""
    echo "🎉 And now, for your entertainment... a developer joke! 🎉"

    API_URL="https://official-joke-api.appspot.com/jokes/programming/random"

    # Fetch the joke and parse it
    # The API returns an array, so we take the first element with [0]
    joke_data=$(curl -s "$API_URL")
    setup=$(echo "$joke_data" | jq -r '.[0].setup')
    punchline=$(echo "$joke_data" | jq -r '.[0].punchline')

    if [ -n "$setup" ] && [ -n "$punchline" ]; then
        echo "   - $setup"
        sleep 2 # Dramatic pause
        echo "   - $punchline"
    else
        echo "Could not fetch a joke this time. You must be funny enough already!"
    fi
    echo ""
}


# --- Main release logic ---
VERSION=$1

if [ -z "$VERSION" ]; then
  echo "Usage: ./scripts/release.sh <version>"
  echo "Example: ./scripts/release.sh v1.0.1"
  exit 1
fi

# Check if the tag already exists
if git rev-parse -q --verify "refs/tags/$VERSION" >/dev/null; then
    echo "Error: Tag $VERSION already exists."
    exit 1
fi

echo "Creating release for version $VERSION..."

# Generate a changelog with git-cliff
git-cliff --tag "$VERSION" --output CHANGELOG.md

# Create the git tag
git tag -a "$VERSION" -m "Release $VERSION"

echo ""
echo "Release $VERSION created successfully."
echo "Run 'git push --tags' to push the new tag to the remote repository."
echo "A CHANGELOG.md file has been generated."

# Display a developer joke as a final touch
get_dev_joke