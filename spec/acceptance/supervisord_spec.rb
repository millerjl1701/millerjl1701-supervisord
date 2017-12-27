require 'spec_helper_acceptance'

describe 'supervisord class' do
  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = <<-EOS
      class { 'supervisord': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe file('/etc/supervisor') do
      it { should be_directory }
      it { should be_mode 755 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
    end

    describe file('/etc/supervisor/conf.d') do
      it { should be_directory }
      it { should be_mode 755 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
    end

    describe file('/var/log/supervisor') do
      it { should be_directory }
      it { should be_mode 755 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
    end

    describe file('/var/run/supervisor') do
      it { should be_directory }
      it { should be_mode 755 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
    end

    describe file('/bin/supervisord') do
      it { should be_file }
      it { should be_mode 755 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
    end

    describe file('/etc/supervisor/supervisord.conf') do
      it { should be_file }
      it { should be_mode 644 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should contain '[unix_http_server]' }
      it { should contain 'file = /var/run/supervisor/supervisor.sock' }
      it { should contain '[supervisord]' }
      it { should contain 'logfile = /var/log/supervisor/supervisord.log' }
      it { should contain 'logfile_maxbytes = 50MB' }
      it { should contain 'logfile_backups = 10' }
      it { should contain 'loglevel = info' }
      it { should contain 'pidfile = /var/run/supervisor/supervisord.pid' }
      it { should contain 'nodaemon = false' }
      it { should contain 'minfds = 1024' }
      it { should contain 'minprocs = 200' }
      it { should contain '[rpcinterface:supervisor]' }
      it { should contain 'supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface' }
      it { should contain '[supervisorctl]' }
      it { should contain 'serverurl = unix:///var/run/supervisor/supervisor.sock' }
      it { should contain '[include]' }
      it { should contain 'files = /etc/supervisor/conf.d/*.conf' }
    end

    describe file('/etc/systemd/system/supervisord.service') do
      it { should be_file }
      it { should be_mode 644 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should contain 'Description=Process Monitoring and Control Daemon' }
    end

    #describe service('supervisord') do
    #  it { should be_enabled }
    #  it { should be_running }
    #end
  end
end
