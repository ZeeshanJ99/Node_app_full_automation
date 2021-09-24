require 'spec_helper'

describe package('nginx') do
  it { should be_installed }
end

describe service("nginx") do
  it { should be_running }
  it { should be_enabled }
end

describe port(80) do
  it { should be_listening }
end

describe package('nodejs') do
  it { should be_installed }
end

describe command('nodejs --version') do
  its(:stdout) { should match /v6./ }
end

describe package('pm2') do
  it { should be_installed.by('npm') }
end

describe package('git') do
  it { should be_installed }
end

describe command('git --version') do
  its(:stdout) { should match /2\.7\../ }
end
