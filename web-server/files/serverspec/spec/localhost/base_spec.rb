require 'spec_helper'

describe package('gcc-c++') do
  it { should be_installed }
end

describe package('make') do
  it { should be_installed }
end

describe package('openssl-devel') do
  it { should be_installed }
end

describe package('GraphicsMagick') do
  it { should be_installed }
end

describe package('git') do
  it { should be_installed }
end

describe package('nginx') do
  it { should be_installed }
end

describe file('/var/log/nginx') do
  it { should be_directory }
end

describe file('/usr/local/bin/node') do
  it { should be_file }
end

describe file('/usr/bin/node') do
  it { should be_file }
end

describe file('/usr/local/bin/npm') do
  it { should be_file }
end

describe file('/usr/bin/npm') do
  it { should be_file }
end

describe file('/etc/init.d/web-api-initd') do
  it { should be_file }
end

describe file('/etc/nginx/sites-available') do
  it { should be_directory }
end

describe file('/etc/nginx/sites-enabled') do
  it { should be_directory }
end

describe file('/etc/nginx/nginx.conf') do
  it { should be_file }
end

describe file('/data/www') do
  it { should be_directory }
end
