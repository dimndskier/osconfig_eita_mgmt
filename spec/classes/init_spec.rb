require 'spec_helper'
describe 'osconfig_eita_mgmt' do

  context 'with defaults for all parameters' do
    it { should contain_class('osconfig_eita_mgmt') }
  end
end
