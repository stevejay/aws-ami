#!/bin/bash
# serverspec.sh - RSpec tests for servers

echo "Installing serverspec"
sudo gem install rake
sudo gem install serverspec

cd /tmp/tests

echo "Running integration tests for ami"
rake spec