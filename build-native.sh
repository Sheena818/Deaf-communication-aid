#!/bin/bash

# ============================================================
# Deaf Communication Aid - Native Mobile App Build Script
# ============================================================
# This script automates the process of building native iOS
# and Android apps using Capacitor.
#
# Usage:
#   ./build-native.sh           # Interactive mode
#   ./build-native.sh ios       # Build iOS only
#   ./build-native.sh android   # Build Android only
#   ./build-native.sh both      # Build both platforms
# ============================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Print banner
echo ""
echo -e "${PURPLE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║${NC}     ${CYAN}Deaf Communication Aid - Native Build Script${NC}          ${PURPLE}║${NC}"
echo -e "${PURPLE}║${NC}     ${YELLOW}Building accessible apps for iOS & Android${NC}           ${PURPLE}║${NC}"
echo -e "${PURPLE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Function to print status messages
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check for required tools
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    # Check Node.js
    if ! command -v node &> /dev/null; then
        print_error "Node.js is not installed. Please install Node.js 18+ from https://nodejs.org/"
        exit 1
    fi
    NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$NODE_VERSION" -lt 18 ]; then
        print_warning "Node.js version $NODE_VERSION detected. Version 18+ is recommended."
    else
        print_success "Node.js $(node -v) detected"
    fi
    
    # Check npm
    if ! command -v npm &> /dev/null; then
        print_error "npm is not installed."
        exit 1
    fi
    print_success "npm $(npm -v) detected"
    
    # Check for Xcode (macOS only)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if command -v xcodebuild &> /dev/null; then
            XCODE_VERSION=$(xcodebuild -version | head -n1)
            print_success "$XCODE_VERSION detected"
        else
            print_warning "Xcode not found. Required for iOS builds."
        fi
    fi
    
    # Check for Android SDK
    if [ -n "$ANDROID_HOME" ] && [ -d "$ANDROID_HOME" ]; then
        print_success "Android SDK found at $ANDROID_HOME"
    elif [ -n "$ANDROID_SDK_ROOT" ] && [ -d "$ANDROID_SDK_ROOT" ]; then
        print_success "Android SDK found at $ANDROID_SDK_ROOT"
    else
        print_warning "Android SDK not found. Set ANDROID_HOME environment variable for Android builds."
    fi
    
    echo ""
}

# Install npm dependencies
install_dependencies() {
    print_status "Installing npm dependencies..."
    npm install
    if [ $? -eq 0 ]; then
        print_success "Dependencies installed successfully"
    else
        print_error "Failed to install dependencies"
        exit 1
    fi
    echo ""
}

# Build web application
build_web() {
    print_status "Building web application..."
    npm run build
    
    if [ -d "dist" ]; then
        print_success "Web build completed successfully"
        print_status "Build output: $(du -sh dist | cut -f1)"
    else
        print_error "Build failed - dist folder not created"
        exit 1
    fi
    echo ""
}

# Build iOS
build_ios() {
    print_status "Building for iOS..."
    
    # Check if running on macOS
    if [[ "$OSTYPE" != "darwin"* ]]; then
        print_error "iOS builds require macOS"
        return 1
    fi
    
    # Check for Xcode
    if ! command -v xcodebuild &> /dev/null; then
        print_error "Xcode is required for iOS builds"
        return 1
    fi
    
    # Add iOS platform if not exists
    if [ ! -d "ios" ]; then
        print_status "Adding iOS platform..."
        npx cap add ios
    else
        print_status "iOS platform already exists"
    fi
    
    # Sync web assets
    print_status "Syncing web assets to iOS..."
    npx cap sync ios
    
    print_success "iOS build ready!"
    echo ""
    
    # Open Xcode
    print_status "Opening Xcode..."
    npx cap open ios
    
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}                    ${GREEN}iOS Build Complete${NC}                      ${CYAN}║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║${NC} Next steps in Xcode:                                       ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  1. Select your Team in Signing & Capabilities            ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  2. Set Bundle Identifier: com.deafcomm.app               ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  3. Add required capabilities (Push, Background Audio)    ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  4. Product → Archive for App Store submission            ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Build Android
build_android() {
    print_status "Building for Android..."
    
    # Add Android platform if not exists
    if [ ! -d "android" ]; then
        print_status "Adding Android platform..."
        npx cap add android
        
        # Copy resource files if they exist
        if [ -d "android-resources" ]; then
            print_status "Copying Android resource files..."
            
            if [ -f "android-resources/strings.xml" ]; then
                cp android-resources/strings.xml android/app/src/main/res/values/strings.xml
                print_success "Copied strings.xml"
            fi
            
            if [ -f "android-resources/colors.xml" ]; then
                cp android-resources/colors.xml android/app/src/main/res/values/colors.xml
                print_success "Copied colors.xml"
            fi
        fi
    else
        print_status "Android platform already exists"
    fi
    
    # Sync web assets
    print_status "Syncing web assets to Android..."
    npx cap sync android
    
    print_success "Android build ready!"
    echo ""
    
    # Open Android Studio
    print_status "Opening Android Studio..."
    npx cap open android
    
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}                  ${GREEN}Android Build Complete${NC}                   ${CYAN}║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║${NC} Next steps in Android Studio:                              ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  1. Wait for Gradle sync to complete                       ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  2. Update app/build.gradle with signing config            ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  3. Build → Generate Signed Bundle / APK                   ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  4. Select Android App Bundle for Play Store               ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Main script logic
main() {
    # Check prerequisites
    check_prerequisites
    
    # Install dependencies
    install_dependencies
    
    # Build web app
    build_web
    
    # Handle command line argument or prompt for platform
    PLATFORM=${1:-""}
    
    if [ -z "$PLATFORM" ]; then
        echo -e "${YELLOW}Select platform to build:${NC}"
        echo "  1) iOS (requires macOS + Xcode)"
        echo "  2) Android"
        echo "  3) Both platforms"
        echo ""
        read -p "Enter choice [1-3]: " choice
        
        case $choice in
            1) PLATFORM="ios" ;;
            2) PLATFORM="android" ;;
            3) PLATFORM="both" ;;
            *)
                print_error "Invalid choice"
                exit 1
                ;;
        esac
    fi
    
    # Build selected platform(s)
    case $PLATFORM in
        ios)
            build_ios
            ;;
        android)
            build_android
            ;;
        both)
            build_ios
            build_android
            ;;
        *)
            print_error "Unknown platform: $PLATFORM"
            echo "Usage: $0 [ios|android|both]"
            exit 1
            ;;
    esac
    
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║${NC}              ${PURPLE}Build Process Complete!${NC}                      ${GREEN}║${NC}"
    echo -e "${GREEN}╠════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${GREEN}║${NC} Documentation:                                             ${GREEN}║${NC}"
    echo -e "${GREEN}║${NC}  - mobile-app/BUILD_INSTRUCTIONS.md                        ${GREEN}║${NC}"
    echo -e "${GREEN}║${NC}  - mobile-app/ANDROID_BUILD_GUIDE.md                       ${GREEN}║${NC}"
    echo -e "${GREEN}║${NC}  - mobile-app/APP_STORE_METADATA.md                        ${GREEN}║${NC}"
    echo -e "${GREEN}║${NC}  - mobile-app/ACCESSIBILITY_COMPLIANCE.md                  ${GREEN}║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Run main function
main "$@"
