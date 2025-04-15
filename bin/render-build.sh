#!/usr/bin/env bash

# Exit on error
set -o errexit

# Install Ruby dependencies
bundle install

# Check if Bun is installed, install if not
if ! command -v bun &> /dev/null; then
  echo "Bun not found, installing..."
  curl -fsSL https://bun.sh/install | bash
  # Update PATH to include Bun for this session
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
else
  echo "Bun is already installed"
fi

# Install and build JavaScript dependencies with Bun
bun install
bun run build
bun run build:css

# Rails asset compilation
bin/rails assets:precompile
bin/rails assets:clean

# Run database migrations
bin/rails db:migrate