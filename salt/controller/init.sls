ssh_private_key:
  file.managed:
    - name: /root/.ssh/id_rsa
    - source: salt://controller/id_rsa
    - makedirs: True
    - user: root
    - group: root
    - mode: 700

ssh_public_key:
  file.managed:
    - name: /root/.ssh/id_rsa.pub
    - source: salt://controller/id_rsa.pub
    - makedirs: True
    - user: root
    - group: root
    - mode: 700

/root/testsuite:
file.recurse:
    - source: salt://controller/testsuite
    - user: root
    - group: root

gemfile_cucumber:
  file.managed:
    - name: /tmp/Gemfile
    - source: salt://controller/Gemfile
    - makedirs: True

authorized_keys_controller:
  file.append:
    - name: /root/.ssh/authorized_keys
    - source: salt://controller/id_rsa.pub
    - makedirs: True

cucumber_requisites:
  pkg.installed:
    - pkgs:
      - gcc
      - make
      - wget
      - ruby
      - ruby-devel
      - autoconf
      - ca-certificates-mozilla
      - automake
      - libtool
      - apache2-worker
      - cantarell-fonts
      - git-core
      - wget
      - aaa_base-extras
      - zlib-devel
      - libxslt-devel
      - mozilla-nss-tools
      # packaged ruby gems
      - ruby2.1-rubygem-bundler
      - screen

chromium_fixed_version:
  pkg.installed:
  - name: chromium
  - version: 64.0.3282.167

chromedriver_fixed_version:
  pkg.installed:
  - name: chromedriver
  - version: 64.0.3282.167

create_syslink_for_chromedriver:
  file.symlink:
    - name: /usr/bin/chromedriver
    - target: /usr/lib64/chromium/chromedriver

install_gems_via_bundle:
  cmd.run:
    - name: bundle.ruby2.1 install --gemfile /tmp/Gemfile
    - require:
      - pkg: cucumber_requisites
      - file: gemfile_cucumber

testsuite_env_vars:
  file.managed:
    - name: /root/.bashrc
    - source: salt://controller/bashrc
    - template: jinja
    - user: root
    - group: root
    - mode: 755

chrome_certs:
  file.directory:
    - user:  root
    - name:  /root/.pki/nssdb
    - group: users
    - mode:  755
    - makedirs: True

google_cert_db:
  cmd.run:
   - name: certutil -d sql:/root/.pki/nssdb -N --empty-password
   - require:
     - file: chrome_certs
