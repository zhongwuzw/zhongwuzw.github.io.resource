#!/bin/bash

REPO="lynx-family/habitat"
API_URL="https://api.github.com/repos/$REPO/releases/latest"

echo "Fetching latest release info from $API_URL"
RELEASE_JSON=$(curl -s "$API_URL")

if [ -z "$RELEASE_JSON" ]; then
  echo "Error: Failed to fetch release data from GitHub API."
  exit 1
fi

DOWNLOAD_URL=$(echo "$RELEASE_JSON" | grep -o '"browser_download_url": "[^"]*hab"' | cut -d'"' -f4)

if [ -z "$DOWNLOAD_URL" ]; then
  echo "Error: No asset with a URL ending in 'hab' found in the latest release."
  echo "Available assets:"
  echo "$RELEASE_JSON" | grep -o '"name": "[^"]*"' | cut -d'"' -f4
  exit 1
fi

FILENAME=$(basename "$DOWNLOAD_URL")

echo "Downloading $FILENAME from $DOWNLOAD_URL"
curl -L -o "$FILENAME" "$DOWNLOAD_URL"

if [ $? -ne 0 ]; then
  echo "Error: Failed to download $FILENAME."
  exit 1
fi

chmod +x "$FILENAME"
