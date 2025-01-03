# Define variables
BINARY_NAME=my-tool  # Replace with your tool's name
BUILD_DIR=build
RELEASE_DIR=$(BUILD_DIR)/release

# Define the install directory
INSTALL_DIR=$(HOME)/.bin

# Define the Swift compiler
SWIFT=swift

# Default target
all: build

# Build the tool in debug mode
build:
	$(SWIFT) build -c debug

# Build the tool in release mode
release:
	$(SWIFT) build -c release

# Install the release build
install: release
	install $(RELEASE_DIR)/$(BINARY_NAME) $(INSTALL_DIR)

# Clean the build directory
clean:
	rm -rf $(BUILD_DIR)

# Uninstall the tool
uninstall:
	rm -f $(INSTALL_DIR)/$(BINARY_NAME)
	