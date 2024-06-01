#!/bin/bash

# Base directory
BASE_DIR=~/code

# Create base directory if it doesn't exist
mkdir -p "$BASE_DIR"

# Create directories
mkdir -p "$BASE_DIR/.github/workflows"
mkdir -p "$BASE_DIR/scripts"
mkdir -p "$BASE_DIR/configs/typescript"
mkdir -p "$BASE_DIR/shared-libs/lib-1/src"
mkdir -p "$BASE_DIR/shared-libs/lib-2/src"
mkdir -p "$BASE_DIR/services/service-1/src"
mkdir -p "$BASE_DIR/services/service-2/src"
mkdir -p "$BASE_DIR/apps/app-1/src"
mkdir -p "$BASE_DIR/apps/app-1/public"
mkdir -p "$BASE_DIR/apps/app-2/src"
mkdir -p "$BASE_DIR/apps/app-2/public"
mkdir -p "$BASE_DIR/tests/e2e"
mkdir -p "$BASE_DIR/tests/utils"
mkdir -p "$BASE_DIR/docs/notes"
mkdir -p "$BASE_DIR/docs/projects/compliance-ontology"

# Create files
touch "$BASE_DIR/README.md"
touch "$BASE_DIR/LICENSE"
touch "$BASE_DIR/.gitignore"
touch "$BASE_DIR/.github/workflows/ci.yml"
touch "$BASE_DIR/scripts/build.sh"
touch "$BASE_DIR/scripts/deploy.sh"
touch "$BASE_DIR/scripts/test.sh"
touch "$BASE_DIR/configs/eslint.json"
touch "$BASE_DIR/configs/prettier.json"
touch "$BASE_DIR/configs/typescript/tsconfig.json"
touch "$BASE_DIR/shared-libs/lib-1/package.json"
touch "$BASE_DIR/shared-libs/lib-1/README.md"
touch "$BASE_DIR/shared-libs/lib-2/package.json"
touch "$BASE_DIR/shared-libs/lib-2/README.md"
touch "$BASE_DIR/services/service-1/package.json"
touch "$BASE_DIR/services/service-1/Dockerfile"
touch "$BASE_DIR/services/service-1/README.md"
touch "$BASE_DIR/services/service-2/package.json"
touch "$BASE_DIR/services/service-2/Dockerfile"
touch "$BASE_DIR/services/service-2/README.md"
touch "$BASE_DIR/apps/app-1/package.json"
touch "$BASE_DIR/apps/app-1/README.md"
touch "$BASE_DIR/apps/app-2/package.json"
touch "$BASE_DIR/apps/app-2/README.md"
touch "$BASE_DIR/tests/e2e/test-case-1.spec.js"
touch "$BASE_DIR/tests/e2e/test-case-2.spec.js"
touch "$BASE_DIR/tests/utils/mock-data.js"
touch "$BASE_DIR/tests/utils/test-helpers.js"
touch "$BASE_DIR/docs/notes/compliance-notes.md"
touch "$BASE_DIR/docs/projects/compliance-ontology/project-plan.md"

# Output completion message
echo "Directory structure created successfully in $BASE_DIR"
