#!/bin/bash

# Navigate to the project root (assumes the script is in scripts/)
cd "$(dirname "$0")/.." || exit

# Track failures
FAILED=false

# Setup centralized coverage
echo "📊 Preparing centralized coverage..."
COVERAGE_DIR="coverage"
# Use a temporary file for aggregation to avoid infinite loops if $dir is .
AGGREGATE_LCOV=$(mktemp)
ROOT_LCOV="$COVERAGE_DIR/lcov.info"

# Ensure clean start
rm -rf "$COVERAGE_DIR"
mkdir -p "$COVERAGE_DIR"

echo "🔍 Searching for packages with tests..."

# Use find to find all directories containing a pubspec.yaml file
# excluding common build directories and hidden ones
DIRS=$(find . -name "pubspec.yaml" -not -path "*/.*" -not -path "*/ios/*" -not -path "*/android/*" -not -path "*/build/*" | xargs -I {} dirname {} | sort -u)

for dir in $DIRS; do
    if [ -d "$dir/test" ]; then
        echo ""
        echo "------------------------------------------------------------"
        echo "🚀 Found tests in: $dir"
        echo "------------------------------------------------------------"

        # Ensure dependencies are resolved
        echo "📦 Getting dependencies in $dir..."
        (cd "$dir" && flutter pub get > /dev/null)

        echo "🧪 Running tests with coverage..."
        # Run tests with coverage and capture success
        if (cd "$dir" && flutter test --coverage); then
            echo "✅ Tests passed in $dir"

            # Check if coverage was generated
            if [ -f "$dir/coverage/lcov.info" ]; then
                echo "📝 Aggregating coverage for $dir..."

                # Clean up the directory path (remove ./ for consistent mapping)
                CLEAN_DIR=$(echo "$dir" | sed 's|^\./||')

                if [ "$CLEAN_DIR" = "." ]; then
                    # For root, just append the content
                    cat "$dir/coverage/lcov.info" >> "$AGGREGATE_LCOV"
                else
                    # Adjust paths to be relative to root
                    # SF:lib/... -> SF:packages/foo/lib/...
                    sed "s|^SF:|SF:$CLEAN_DIR/|g" "$dir/coverage/lcov.info" >> "$AGGREGATE_LCOV"
                fi
            else
                echo "⚠️ No coverage file found at $dir/coverage/lcov.info"
            fi
        else
            echo "❌ Tests failed in $dir"
            FAILED=true
        fi
    fi
done

# Move aggregated content to the final destination
if [ -s "$AGGREGATE_LCOV" ]; then
    cp "$AGGREGATE_LCOV" "$ROOT_LCOV"
    echo "📈 Centralized coverage report: $ROOT_LCOV"
else
    echo "⚠️ No coverage data was collected."
fi

# Clean up temp file
rm "$AGGREGATE_LCOV"

if [ "$FAILED" = true ]; then
    echo ""
    echo "⚠️ Some tests failed. Centralized coverage might be incomplete."
    exit 1
else
    echo ""
    echo "🎉 All tests passed!"
    exit 0
fi
