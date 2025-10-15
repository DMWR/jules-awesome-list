#!/bin/bash
set -e

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

# Get the latest tag to generate a changelog from that point
LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "")

# Generate a changelog
echo "# Changelog" > CHANGELOG.md
echo "" >> CHANGELOG.md
echo "## Version $VERSION" >> CHANGELOG.md

if [ -z "$LATEST_TAG" ]; then
  # If no tags exist, log all history
  git log --pretty=format:"- %s" >> CHANGELOG.md
else
  # Log history since the latest tag
  git log "${LATEST_TAG}..HEAD" --pretty=format:"- %s" >> CHANGELOG.md
fi

# Create the git tag
git tag -a "$VERSION" -m "Release $VERSION"

echo "" >> CHANGELOG.md

echo ""
echo "Release $VERSION created successfully."
echo "Run 'git push --tags' to push the new tag to the remote repository."
echo "A CHANGELOG.md file has been generated."