require 'spec_helper'

describe package 'mongodb-org' do
  it { should be_installed.with_version('3.2.20') }
end

describe service 'mongod' do
  it { should be_running }
  it { should be_enabled }
end

describe port(27017) do
  it { should be_listening.on('0.0.0.0') }
end
