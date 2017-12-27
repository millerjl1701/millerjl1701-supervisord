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

          it { is_expected.to contain_class('supervisord::python') }
          it { is_expected.to contain_class('supervisord::install') }
          it { is_expected.to contain_class('supervisord::config') }
          it { is_expected.to contain_class('supervisord::service') }
          it { is_expected.to contain_class('supervisord::python').that_comes_before('Class[supervisord::install]') }
          it { is_expected.to contain_class('supervisord::install').that_comes_before('Class[supervisord::config]') }
          it { is_expected.to contain_class('supervisord::service').that_subscribes_to('Class[supervisord::config]') }
          it { is_expected.to contain_class('systemd::systemctl::daemon_reload') }

          it { is_expected.to contain_class('epel') }
          it { is_expected.to contain_yumrepo('epel') }

          it { is_expected.to contain_class('python').with(
            'dev'             => 'present',
            'manage_gunicorn' => false,
            'use_epel'        => true,
            'virtualenv'      => 'present',
          ) }

          it { is_expected.to contain_file('/etc/supervisor').with(
            'ensure' => 'directory',
            'owner'  => 'root',
            'group'  => 'root',
            'mode'   => '0755',
          ) }

          it { is_expected.to contain_file('/etc/supervisor/conf.d').with(
            'ensure' => 'directory',
            'owner'  => 'root',
            'group'  => 'root',
            'mode'   => '0755',
          ) }

          it { is_expected.to contain_file('/var/log/supervisor').with(
            'ensure' => 'directory',
            'owner'  => 'root',
            'group'  => 'root',
            'mode'   => '0755',
          ) }

          it { is_expected.to contain_file('/var/run/supervisor').with(
            'ensure' => 'directory',
            'owner'  => 'root',
            'group'  => 'root',
            'mode'   => '0755',
          ) }

          it { is_expected.to contain_python__pip('supervisor').with(
            'pkgname'    => 'supervisor',
            'ensure'     => 'present',
            'virtualenv' => 'system',
            'owner'      => 'root',
          ) }

          it { is_expected.to contain_file('/etc/supervisor/supervisord.conf').with(
            'ensure' => 'present',
            'owner'  => 'root',
            'group'  => 'root',
            'mode'   => '0644',
          ) }

          it { is_expected.to contain_ini_setting('include files').with(
            'ensure'  => 'present',
            'path'    => '/etc/supervisor/supervisord.conf',
            'section' => 'include',
            'setting' => 'files',
            'value'   => '/etc/supervisor/conf.d/*.conf',
          ) }

          it { is_expected.to contain_ini_setting('rpcinterface:supervisor supervisor.rpcinterface_factory').with(
            'ensure'  => 'present',
            'path'    => '/etc/supervisor/supervisord.conf',
            'section' => 'rpcinterface:supervisor',
            'setting' => 'supervisor.rpcinterface_factory',
            'value'   => 'supervisor.rpcinterface:make_main_rpcinterface',
          ) }

          it { is_expected.to contain_ini_setting('supervisorctl serverurl').with(
            'ensure'  => 'present',
            'path'    => '/etc/supervisor/supervisord.conf',
            'section' => 'supervisorctl',
            'setting' => 'serverurl',
            'value'   => 'unix:///var/run/supervisor/supervisor.sock',
          ) }

          it { is_expected.to contain_ini_setting('supervisord logfile').with(
            'ensure'  => 'present',
            'path'    => '/etc/supervisor/supervisord.conf',
            'section' => 'supervisord',
            'setting' => 'logfile',
            'value'   => '/var/log/supervisor/supervisord.log',
          ) }

          it { is_expected.to contain_ini_setting('supervisord logfile_maxbytes').with(
            'ensure'  => 'present',
            'path'    => '/etc/supervisor/supervisord.conf',
            'section' => 'supervisord',
            'setting' => 'logfile_maxbytes',
            'value'   => '50MB',
          ) }

          it { is_expected.to contain_ini_setting('supervisord logfile_backups').with(
            'ensure'  => 'present',
            'path'    => '/etc/supervisor/supervisord.conf',
            'section' => 'supervisord',
            'setting' => 'logfile_backups',
            'value'   => '10',
          ) }

          it { is_expected.to contain_ini_setting('supervisord loglevel').with(
            'ensure'  => 'present',
            'path'    => '/etc/supervisor/supervisord.conf',
            'section' => 'supervisord',
            'setting' => 'loglevel',
            'value'   => 'info',
          ) }

          it { is_expected.to contain_ini_setting('supervisord pidfile').with(
            'ensure'  => 'present',
            'path'    => '/etc/supervisor/supervisord.conf',
            'section' => 'supervisord',
            'setting' => 'pidfile',
            'value'   => '/var/run/supervisor/supervisord.pid',
          ) }

          it { is_expected.to contain_ini_setting('supervisord nodaemon').with(
            'ensure'  => 'present',
            'path'    => '/etc/supervisor/supervisord.conf',
            'section' => 'supervisord',
            'setting' => 'nodaemon',
            'value'   => 'false',
          ) }

          it { is_expected.to contain_ini_setting('supervisord minfds').with(
            'ensure'  => 'present',
            'path'    => '/etc/supervisor/supervisord.conf',
            'section' => 'supervisord',
            'setting' => 'minfds',
            'value'   => '1024',
          ) }

          it { is_expected.to contain_ini_setting('supervisord minprocs').with(
            'ensure'  => 'present',
            'path'    => '/etc/supervisor/supervisord.conf',
            'section' => 'supervisord',
            'setting' => 'minprocs',
            'value'   => '200',
          ) }

          it { is_expected.to contain_ini_setting('unix_http_server file').with(
            'ensure'  => 'present',
            'path'    => '/etc/supervisor/supervisord.conf',
            'section' => 'unix_http_server',
            'setting' => 'file',
            'value'   => '/var/run/supervisor/supervisor.sock',
          ) }

          it { is_expected.to contain_file('/etc/systemd/system/supervisord.service').with(
            'ensure' => 'file',
            'owner'  => 'root',
            'group'  => 'root',
            'mode'   => '0644',
          ) }
          it { is_expected.to contain_file('/etc/systemd/system/supervisord.service').that_notifies('Class[systemd::systemctl::daemon_reload]') }

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
