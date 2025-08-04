#!/bin/bash

set -e

REPO_URL="git@github.com:lakshaychhabra/lucven.git"
BRANCH="gh-pages"

echo "🧹 Cleaning up previous .git in public/"
rm -rf public/.git

echo "lucven.com" > public/CNAME


echo "🛠  Building site with Hugo..."
hugo

echo "🚀 Deploying to $BRANCH branch..."

cd public
git init
git remote add origin "$REPO_URL"
git checkout -b "$BRANCH"

git add .
git commit -m "Deploy site on $(date '+%Y-%m-%d %H:%M:%S')"
git push -f origin "$BRANCH"

cd ..
rm -rf public/.git

echo "✅ Deployment complete. Site should be live in ~30 seconds."
