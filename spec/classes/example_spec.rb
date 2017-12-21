require 'spec_helper'

describe 'supervisord' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "supervisord class without any parameters changed from defaults" do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('supervisord::install') }
          it { is_expected.to contain_class('supervisord::config') }
          it { is_expected.to contain_class('supervisord::service') }
          it { is_expected.to contain_class('supervisord::install').that_comes_before('Class[supervisord::config]') }
          it { is_expected.to contain_class('supervisord::service').that_subscribes_to('Class[supervisord::config]') }

          it { is_expected.to contain_package('supervisord').with_ensure('present') }

          it { is_expected.to contain_service('supervisord').with(
            'ensure'     => 'running',
            'enable'     => 'true',
            'hasstatus'  => 'true',
            'hasrestart' => 'true',
          ) }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'supervisord class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          :osfamily        => 'Solaris',
          :operatingsystem => 'Nexenta',
        }
      end

      it { expect { is_expected.to contain_package('supervisord') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
