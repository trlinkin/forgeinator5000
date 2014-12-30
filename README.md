# forge-inator5000
[![Build Status](https://travis-ci.org/jolshevski/forgeinator5000.svg)](https://travis-ci.org/jolshevski/forgeinator5000)
[![Gem Version](https://badge.fury.io/rb/forgeinator5000.svg)](http://badge.fury.io/rb/forgeinator5000)

Your own personal Puppet Forge.

## Background
The forgeinator implements the Puppetlabs forge API to serve modules.  It can serve internally curated modules and mirror public forge modules.

## Requirements
  * Git
  * Ruby >1.8.7
  * gcc-c++
  * /etc/forgeinator5000/modules (module tarballs will be stored here)

## Installation

### Puppet / Puppet Enterprise
```
puppet module install jordan-forgeinator
puppet apply -e 'include forgeinator' OR a more appropriate means of classification if using a Puppet master
```

### Rubygems
```
gem install forgeinator
```

## Usage
### Starting the API Server
Once the forgeinator is installed, it can be started by running the command `forgeinator serve`.  See the Puppet module for details on daemonizing.

### Adding Modules
Module tarballs will be served from /etc/forgeinator5000/modules.  Non-forge modules need to be built with `puppet module build` before being served.

To point a Puppet agent to the forgeinator, set module_repository to the URL of your forgeinator.
```
puppet module search jordan-gifcat --module_repository http://forge.internal.exampleorg.local
```

### r10k Integration
The forgeinator can download forge modules referenced by an r10k control repository.  
`forgeinator update https://github.com/jolshevski/puppet_control_test.git`
Repository path can be supplied in /etc/forgeinator5000/repo rather then being specific each time update is run.

### Dashboard
A listing of all available modules and their versions is served at /.

## Getting Help
If you run into an issue and need help, please open a new issue on the Github repo.
