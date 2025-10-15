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

# Generate a changelog with git-cliff
git-cliff --tag "$VERSION" --output CHANGELOG.md

# Create the git tag
git tag -a "$VERSION" -m "Release $VERSION"

echo ""
echo "Release $VERSION created successfully."
echo "Run 'git push --tags' to push the new tag to the remote repository."
echo "A CHANGELOG.md file has been generated."