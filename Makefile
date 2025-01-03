# Swift compiler settings
SWIFT = swift
SWIFT_BUILD_FLAGS = -c release

# Project settings
PROJECT_NAME = MyProject
SOURCES = $(wildcard Sources/**/*.swift)

# Directories
BUILD_DIR = .build
RELEASE_DIR = $(BUILD_DIR)/release

# Main targets
all: build

# Build the project
build:
	$(SWIFT) build $(SWIFT_BUILD_FLAGS)

# Generate Xcode project
xcode:
	swift package generate-xcodeproj

# Clean build artifacts
clean:
	$(SWIFT) package clean
	rm -rf $(BUILD_DIR)
	rm -rf *.xcodeproj

# Run the executable
run: build
	$(SWIFT) run $(PROJECT_NAME)

# Run tests
test:
	$(SWIFT) test

# Update dependencies
update:
	$(SWIFT) package update

.PHONY: all build xcode clean run test update
