#!/usr/bin/env bash

# All tests except for non web tests run on chrome
# 
# Non web tests are tagged with "non_web"

# Running VM tests
echo -e "\n🚀 Starting VM tests (non_web)...\n"
flutter test --tags non_web
if [ $? -eq 0 ]; then
    echo -e "\n✅ VM tests completed successfully!\n"
else
    echo -e "\n❌ VM tests failed.\n"
fi

# Running Chrome tests
echo -e "🚀 Starting tests on Chrome...\n"
flutter test --platform chrome 
if [ $? -eq 0 ]; then
    echo -e "\n✅ Chrome tests completed successfully!\n"
else
    echo -e "\n❌ Chrome tests failed.\n"
fi

# Running Integration tests
echo -e "\n🚀 Starting integration tests...\n"
flutter run integration_test/html_color_input_test.dart -d chrome --web-renderer html
if [ $? -eq 0 ]; then
    echo -e "\n✅ Integration tests completed successfully!\n"
else
    echo -e "\n❌ Integration tests failed.\n"
fi