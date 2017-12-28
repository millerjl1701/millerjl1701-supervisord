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

        context 'supervisor class with manage_python set to false' do
          let(:params){
            {
              :manage_python => false,
            }
          }

          it { is_expected.to_not contain_class('epel') }
          it { is_expected.to_not contain_yumrepo('epel') }
          it { is_expected.to_not contain_class('python') }
        end

        context 'supervisor class with supervisord_confdir set to /etc/foo' do
          let(:params){
            {
              :supervisord_confdir => '/etc/foo',
            }
          }

          it { is_expected.to contain_file('/etc/foo').with_ensure('directory') }
          it { is_expected.to contain_file('/etc/foo/conf.d').with_ensure('directory') }
          it { is_expected.to contain_ini_setting('include files').with_value('/etc/foo/conf.d/*.conf') }
          it { is_expected.to contain_ini_setting('include files').with_path('/etc/foo/supervisord.conf') }
          it { is_expected.to contain_file('/etc/foo/supervisord.conf').with_ensure('present') }

        end

        context 'supervisor class with supervisord_logdir set to /opt/supervisor/var/log' do
          let(:params){
            {
              :supervisord_logdir => '/opt/supervisor/var/log',
            }
          }

          it { is_expected.to contain_file('/opt/supervisor/var/log').with_ensure('directory') }
          it { is_expected.to contain_ini_setting('supervisord logfile').with_value('/opt/supervisor/var/log/supervisord.log') }
        end

        context 'supervisor class with supervisord_rundir set to /opt/supervisor/var/run' do
          let(:params){
            {
              :supervisord_rundir => '/opt/supervisor/var/run',
            }
          }

          it { is_expected.to contain_file('/opt/supervisor/var/run').with_ensure('directory') }
          it { is_expected.to contain_ini_setting('unix_http_server file').with_value('/opt/supervisor/var/run/supervisor.sock') }
          it { is_expected.to contain_ini_setting('supervisord pidfile').with_value('/opt/supervisor/var/run/supervisord.pid') }
          it { is_expected.to contain_ini_setting('supervisorctl serverurl').with_value('unix:///opt/supervisor/var/run/supervisor.sock') }
        end

        context 'supervisor class with package_name set to foo' do
          let(:params){
            {
              :package_name => 'foo',
            }
          }

          it { is_expected.to contain_python__pip('foo').with_pkgname('foo') }
        end

        context 'supervisor class with package_ensure set to latest' do
          let(:params){
            {
              :package_ensure => 'latest',
            }
          }

          it { is_expected.to contain_python__pip('supervisor').with_ensure('latest') }
        end

        context 'supervisor class with virtualenv set to /opt/supervisor and virtualenv_owner set to foo' do
          let(:params){
            {
              :virtualenv => '/opt/supervisor',
              :virtualenv_owner => 'foo',
            }
          }

          it { is_expected.to contain_python__pip('supervisor').with_virtualenv('/opt/supervisor') }
          it { is_expected.to contain_python__pip('supervisor').with_owner('foo') }
        end

        context 'supervisor class with supervisord_ini_present set to change a default setting' do
          let(:params){
            {
              :supervisord_ini_present => { 'include' => { 'files' => '/opt/supervisor/conf.d/*.conf' } },
            }
          }

          it { is_expected.to contain_ini_setting('include files').with(
            'ensure'  => 'present',
            'path'    => '/etc/supervisor/supervisord.conf',
            'section' => 'include',
            'setting' => 'files',
            'value'   => '/opt/supervisor/conf.d/*.conf',
          ) }
        end

        context 'supervisor class with supervisord_ini_present set to add settings' do
          let(:params){
            {
              :supervisord_ini_present => { 'foo' => { 'bar' => 'foooooobaaaaaar' } },
            }
          }

          it { is_expected.to contain_ini_setting('foo bar').with(
            'ensure'  => 'present',
            'path'    => '/etc/supervisor/supervisord.conf',
            'section' => 'foo',
            'setting' => 'bar',
            'value'   => 'foooooobaaaaaar',
          ) }
        end

        context 'supervisor class with supervisord_ini_absent set to remove a setting if present' do
          let(:params){
            {
              :supervisord_ini_absent => { 'foo' => { 'bar' => 'foooooobaaaaaar' } },
            }
          }

          it { is_expected.to contain_ini_setting('foo bar').with(
            'ensure'  => 'absent',
            'path'    => '/etc/supervisor/supervisord.conf',
            'section' => 'foo',
            'setting' => 'bar',
            'value'   => 'foooooobaaaaaar',
          ) }
        end

        context 'supervisor class with manage_systemd_unit set to false' do
          let(:params){
            {
              :manage_systemd_unit => false,
            }
          }

          it { is_expected.to_not contain_class('systemd::systemctl::daemon_reload') }
          it { is_expected.to_not contain_file('/etc/systemd/system/supervisord.service') }
        end

        context 'supervisor class with manage_service set to false' do
          let(:params){
            {
              :manage_service => false,
            }
          }

          it { is_expected.to_not contain_service('supervisord') }
        end

        context 'supervisor class with service_name set to foo' do
          let(:params){
            {
              :service_name => 'foo',
            }
          }

          it { is_expected.to contain_service('foo') }
        end

        context 'supervisor class with service_enable set to false and service_ensure set to stopped' do
          let(:params){
            {
              :service_enable => false,
              :service_ensure => 'stopped',
            }
          }

          it { is_expected.to contain_service('supervisord').with(
            'ensure' => 'stopped',
            'enable' => 'false',
          )}
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
