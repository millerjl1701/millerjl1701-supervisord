# supervisord

master branch: [![Build Status](https://secure.travis-ci.org/millerjl1701/millerjl1701-supervisord.png?branch=master)](http://travis-ci.org/millerjl1701/millerjl1701-supervisord)

#### Table of Contents

1. [Module Description - What the module does and why it is useful](#module-description)
1. [Setup - The basics of getting started with supervisord](#setup)
    * [What supervisord affects](#what-supervisord-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with supervisord](#beginning-with-supervisord)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Module Description

This module installs, configures, and manages supervisord while minimizing the use of opinionated templates or sets of parameters.

For more details on supervisor and the capabilities it provides, please see [http://supervisord.org/index.html](http://supervisord.org/index.html)

This module uses Puppet 4 data types as well as providing puppet data in the module. It will not work with puppet versions earlier than 4.7 and is currently written to support supervisor on CentOS/RHEL 7. Other operating systems will be added if time permits.

This module relies on the [stankevich/python](https://forge.puppet.com/stankevich/python) python module for installation of pip and supervisor; however, the management of python can be disabled in the supervisord module if you are already using a different method for installation of the python prerequisites. Also, the management of the supervisord.service unit file and the systemd service management can be disabled in this module if another method is currently in use for managing these items.

At this time, this module is not capable of managing groups or programs in the /etc/supervisor/conf.d directory. This will be added at a later time using similar methods to the management of settings in /etc/supervisor/supervisord.conf .

This module was written primarily in support management of Galaxy, an open web-based platform for accessible, reproducible, and transparent computational biomedical research. Use of this module for other purposes may work.

* [Galaxy Project Web Site](https://galaxyproject.org/)
* [Galaxy Documentation](https://galaxyproject.org/docs/)
* [Galaxy Code Repository](https://github.com/galaxyproject/galaxy)

## Setup

### What supervisord affects

* Package(s): supervisor (via pip, not epel or other package repositories), python-dev, python2-pip, python-virtualenv.
* File(s):
    * /etc/supervisor
    * /etc/supervisor/conf.d
    * /etc/supervisor/supervisord.conf
    * /etc/systemd/system/supervisord.service
    * /var/log/supervisor
    * /var/run/supervisor
* Service(s): supervisord.service

### Setup Requirements

This module depends on the following puppet modules:

* [camptocamp-systemd](https://forge.puppet.com/camptocamp/systemd)
* [puppetlabs-inifile](https://forge.puppet.com/puppetlabs/inifile)
* [puppetlabs-stdlib](https://forge.puppet.com/puppetlabs/stdlib)
* [stankevich-python](https://forge.puppet.com/stankevich/python)

The [stahnma-epel](https://forge.puppet.com/stahnma/epel) module is listed in the metadata.json file as a dependency as well, since stankevich-python lists it as a dependency. A parameter for this module is provided to disable the use of epel for package installation should you be using yumrepo resources or Spacewalk package management instead. By default, use of the epel repository is enabled in order to allow for beaker acceptance testing to function correctly.

### Beginning with supervisord

`include supervisord` should be all that is needed to install, configure, and start the supervisord service using the default parameters.

The version of supervisor at the time of initial authoring was 3.3.3. The default settings for supervisord where taken from the echo_supervisord_conf command.

## Usage

### Using the supervisord module without relying on EPEL to provide python packages

```yaml
---
supervisord::manage_python_use_epel: false
```

### Using the supervisord module for installation and configuration but not service management

```ruby
class { 'supervisord':
  manage_systemd_unit => false,
  manage_service => false,
}
```

This allows for other modules to manage systemd services and unit files instead of the methods provided here.

### Passing a hash to override one of the default INI settings in supervisord.conf using a class declaration

```ruby
class { 'supervisord':
  supervisord_ini_present => { 
    'include' => { 
      'files' => '/opt/supervisor/conf.d/*.conf'
    }
  },
}
```

This changes the directory where extra supervisord configuration files should be loaded from.

### Passing a hash to override one of the default INI settings in supervisord.conf using hiera

```yaml
---
supervisord::supervisord_ini_present:
  'include':
    'files': '/opt/supervisor/conf.d/*.conf'
```

## Reference

Generated puppet strings documentation with examples is available from [https://millerjl1701.github.io/millerjl1701-supervisord](https://millerjl1701.github.io/millerjl1701-supervisord).

The puppet strings documentation is also included in the /docs folder.

### Public Classes

* supervisord: Main class which install and configures the supervisord service. Parameters may be passed via class declaration or hiera.

### Private Classes

* supervisord::config: Class for configuring the supervisord service.
* supervisord::install: Class for setting up necessary directories and installing the supervisor package.
* supervisord::python: Class for managing python dependencies, providing pip installation methods, and optional virtualenv support.
* supervisord::service: Class for managing the supervisord service.

## Limitations

This module is currently written for CentOS/RHEL 7 only. Other operating systems will be added as time permits (unless someone submits a PR first. :)

Currently, supervisor program and group configuration files in /etc/supervisor/conf.d are not managed with this module. These features will be added over time using similar ini_setting methods used for management of the /etc/supervisor/supervisord.conf file.

No validation or testing of the /etc/supervisor/supervisord.conf file is done other than validation of the data types passed to the class. Passing appropriate parameters and values for the supervisord service to use is left as an exercise for the reader.

## Development

Please see the [CONTRIBUTING document](CONTRIBUTING.md) for information on how to get started developing code and submit a pull request for this module. While written in an opinionated fashion at the start, over time this can become less and less the case.

### Contributors

To see who is involved with this module, see the [GitHub list of contributors](https://github.com/millerjl1701/millerjl1701-supervisord/graphs/contributors) or the [CONTRIBUTORS document](CONTRIBUTORS).

## Credits

Since this module is designed primarily for the management of Galaxy processes, the [Galaxy Project Administration Training repository](https://github.com/galaxyproject/dagobah-training/) was used heavily to guide how supervisor is configured and used. Thank you to all the instructors past and present who have developed and published these materials.