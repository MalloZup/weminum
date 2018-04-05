{% for keypath in grains.get('gpg_keys') | default([], true) %}
{% set keyname =  salt['file.basename'](keypath)  %}
gpg_key_copy_{{ keypath }}:
  file.managed:
    - name: /tmp/{{ keyname }}
    - source: salt://{{ keypath }}
install_{{ keypath }}:
  cmd.wait:
    - name: rpm --import /tmp/{{ salt['file.basename'](keypath) }}
    - watch:
      - file: /tmp/{{ keyname }}
{% endfor %}

{% if grains['os'] == 'SUSE' %}

{% if grains['osrelease'] == '42.3' %}
os_pool_repo:
  file.managed:
    - name: /etc/zypp/repos.d/openSUSE-Leap-42.3-Pool.repo
    - source: salt://default/repos.d/openSUSE-Leap-42.3-Pool.repo
    - template: jinja

os_update_repo:
  file.managed:
    - name: /etc/zypp/repos.d/openSUSE-Leap-42.3-Update.repo
    - source: salt://default/repos.d/openSUSE-Leap-42.3-Update.repo
    - template: jinja

tools_pool_repo:
  file.managed:
    - name: /etc/zypp/repos.d/systemsmanagement-saltstack_products-next.repo
    - source: salt://default/repos.d/systemsmanagement-saltstack_products-next.repo
    - template: jinja

tools_update_repo:
  file.touch:
    - name: /tmp/no_tools_update_repo_needed

tools_devel_repo:
  file.touch:
    - name: /tmp/no_tools_devel_repo_needed
{% endif %}


{% if grains['osrelease'] == '11.4' %}

os_pool_repo:
  file.managed:
    - name: /etc/zypp/repos.d/SLE-11-SP4-x86_64-Pool.repo
    - source: salt://default/repos.d/SLE-11-SP4-x86_64-Pool.repo
    - template: jinja

os_update_repo:
  file.managed:
    - name: /etc/zypp/repos.d/SLE-11-SP4-x86_64-Update.repo
    - source: salt://default/repos.d/SLE-11-SP4-x86_64-Update.repo
    - template: jinja

{% if grains.get('use_unreleased_updates') | default(False, true) %}
test_update_repo:
  file.managed:
    - name: /etc/zypp/repos.d/SLE-11-SP4-x86_64-Test-Update.repo
    - source: salt://default/repos.d/SLE-11-SP4-x86_64-Test-Update.repo
    - template: jinja
{% endif %}

tools_pool_repo:
  file.managed:
    - name: /etc/zypp/repos.d/SLE-Manager-Tools-SLE-11-x86_64.repo
    - source: salt://default/repos.d/SLE-Manager-Tools-SLE-11-x86_64.repo
    - template: jinja

tools_update_repo:
  file.touch:
    - name: /tmp/no_tools_update_repo_needed

{% if 'released' in grains.get('version') | default('released', true) %}

tools_devel_repo:
  file.touch:
    - name: /tmp/no_tools_devel_repo_needed

{% elif '3.0-nightly' in grains.get('version') | default('', true) %}

tools_devel_repo:
  file.managed:
    - name: /etc/zypp/repos.d/Devel_Galaxy_Manager_3.0_SLE-Manager-Tools-11-x86_64.repo
    - source: salt://default/repos.d/Devel_Galaxy_Manager_3.0_SLE-Manager-Tools-11-x86_64.repo
    - template: jinja

{% elif 'nightly' in grains.get('version') | default('', true) %}

tools_devel_repo:
  file.managed:
    - name: /etc/zypp/repos.d/Devel_Galaxy_Manager_3.1_SLE-Manager-Tools-11-x86_64.repo
    - source: salt://default/repos.d/Devel_Galaxy_Manager_3.1_SLE-Manager-Tools-11-x86_64.repo
    - template: jinja

{% elif 'head' in grains.get('version') | default('', true) %}

tools_devel_repo:
  file.managed:
    - name: /etc/zypp/repos.d/Devel_Galaxy_Manager_Head_SLE-Manager-Tools-11-x86_64.repo
    - source: salt://default/repos.d/Devel_Galaxy_Manager_Head_SLE-Manager-Tools-11-x86_64.repo
    - template: jinja

{% endif %}

{% endif %}


{% if '12' in grains['osrelease'] %}
{% if grains['osrelease'] == '12' %}
os_pool_repo:
  file.managed:
    - name: /etc/zypp/repos.d/SLE-12-x86_64-Pool.repo
    - source: salt://default/repos.d/SLE-12-x86_64-Pool.repo
    - template: jinja

os_update_repo:
  file.managed:
    - name: /etc/zypp/repos.d/SLE-12-x86_64-Update.repo
    - source: salt://default/repos.d/SLE-12-x86_64-Update.repo
    - template: jinja

{% if grains.get('use_unreleased_updates') | default(False, true) %}
test_update_repo:
  file.managed:
    - name: /etc/zypp/repos.d/SLE-12-x86_64-Test-Update.repo
    - source: salt://default/repos.d/SLE-12-x86_64-Test-Update.repo
    - template: jinja
{% endif %}

{% elif grains['osrelease'] == '12.1' %}

os_pool_repo:
  file.managed:
    - name: /etc/zypp/repos.d/SLE-12-SP1-x86_64-Pool.repo
    - source: salt://default/repos.d/SLE-12-SP1-x86_64-Pool.repo
    - template: jinja

os_update_repo:
  file.managed:
    - name: /etc/zypp/repos.d/SLE-12-SP1-x86_64-Update.repo
    - source: salt://default/repos.d/SLE-12-SP1-x86_64-Update.repo
    - template: jinja

{% if grains.get('use_unreleased_updates') | default(False, true) %}
test_update_repo:
  file.managed:
    - name: /etc/zypp/repos.d/SLE-12-SP1-x86_64-Test-Update.repo
    - source: salt://default/repos.d/SLE-12-SP1-x86_64-Test-Update.repo
    - template: jinja
{% endif %}

{% elif grains['osrelease'] == '12.2' %}

os_pool_repo:
  file.managed:
    - name: /etc/zypp/repos.d/SLE-12-SP2-x86_64-Pool.repo
    - source: salt://default/repos.d/SLE-12-SP2-x86_64-Pool.repo
    - template: jinja

os_update_repo:
  file.managed:
    - name: /etc/zypp/repos.d/SLE-12-SP2-x86_64-Update.repo
    - source: salt://default/repos.d/SLE-12-SP2-x86_64-Update.repo
    - template: jinja

{% if grains.get('use_unreleased_updates') | default(False, true) %}
test_update_repo:
  file.managed:
    - name: /etc/zypp/repos.d/SLE-12-SP2-x86_64-Test-Update.repo
    - source: salt://default/repos.d/SLE-12-SP2-x86_64-Test-Update.repo
    - template: jinja
{% endif %}

{% elif grains['osrelease'] == '12.3' %}

os_pool_repo:
  file.managed:
    - name: /etc/zypp/repos.d/SLE-12-SP3-x86_64-Pool.repo
    - source: salt://default/repos.d/SLE-12-SP3-x86_64-Pool.repo
    - template: jinja

os_update_repo:
  file.managed:
    - name: /etc/zypp/repos.d/SLE-12-SP3-x86_64-Update.repo
    - source: salt://default/repos.d/SLE-12-SP3-x86_64-Update.repo
    - template: jinja

{% if grains.get('use_unreleased_updates') | default(False, true) %}
test_update_repo:
  file.managed:
    - name: /etc/zypp/repos.d/SLE-12-SP3-x86_64-Test-Update.repo
    - source: salt://default/repos.d/SLE-12-SP3-x86_64-Test-Update.repo
    - template: jinja
{% endif %}

{% endif %}

tools_pool_repo:
  file.managed:
    - name: /etc/zypp/repos.d/SLE-Manager-Tools-SLE-12-x86_64-Pool.repo
    - source: salt://default/repos.d/SLE-Manager-Tools-SLE-12-x86_64-Pool.repo
    - template: jinja

tools_update_repo:
  file.managed:
    - name: /etc/zypp/repos.d/SLE-Manager-Tools-SLE-12-x86_64-Update.repo
    - source: salt://default/repos.d/SLE-Manager-Tools-SLE-12-x86_64-Update.repo
    - template: jinja

{% if 'released' in grains.get('version') | default('released', true) %}

tools_devel_repo:
  file.touch:
    - name: /tmp/no_tools_devel_repo_needed

{% elif '3.0-nightly' in grains.get('version') | default('', true) %}

tools_devel_repo:
  file.managed:
    - name: /etc/zypp/repos.d/Devel_Galaxy_Manager_3.0_SLE-Manager-Tools-12-x86_64.repo
    - source: salt://default/repos.d/Devel_Galaxy_Manager_3.0_SLE-Manager-Tools-12-x86_64.repo
    - template: jinja

{% elif 'nightly' in grains.get('version') | default('', true) %}

tools_devel_repo:
  file.managed:
    - name: /etc/zypp/repos.d/Devel_Galaxy_Manager_3.1_SLE-Manager-Tools-12-x86_64.repo
    - source: salt://default/repos.d/Devel_Galaxy_Manager_3.1_SLE-Manager-Tools-12-x86_64.repo
    - template: jinja

{% elif ('head' in grains.get('version') | default('', true)) or ('test' in grains.get('version') | default('', true)) %}
tools_devel_repo:
  file.managed:
    - name: /etc/zypp/repos.d/Devel_Galaxy_Manager_Head_SLE-Manager-Tools-12-x86_64.repo
    - source: salt://default/repos.d/Devel_Galaxy_Manager_Head_SLE-Manager-Tools-12-x86_64.repo
    - template: jinja

{% endif %}
{% endif %}


{% if '15' in grains['osrelease'] %}
{% if grains['osrelease'] == '15' %}
os_pool_repo:
  file.managed:
    - name: /etc/zypp/repos.d/SLE-15-x86_64-Pool.repo
    - source: salt://default/repos.d/SLE-15-x86_64-Pool.repo
    - template: jinja

os_update_repo:
  file.managed:
    - name: /etc/zypp/repos.d/SLE-15-x86_64-Update.repo
    - source: salt://default/repos.d/SLE-15-x86_64-Update.repo
    - template: jinja

{% if grains.get('use_unreleased_updates') | default(False, true) %}
test_update_repo:
  file.managed:
    - name: /etc/zypp/repos.d/SLE-15-x86_64-Test-Update.repo
    - source: salt://default/repos.d/SLE-15-x86_64-Test-Update.repo
    - template: jinja
{% endif %}
{% endif %}

tools_pool_repo:
  file.managed:
    - name: /etc/zypp/repos.d/SLE-Manager-Tools-SLE-15-x86_64-Pool.repo
    - source: salt://default/repos.d/SLE-Manager-Tools-SLE-15-x86_64-Pool.repo
    - template: jinja

tools_update_repo:
  file.managed:
    - name: /etc/zypp/repos.d/SLE-Manager-Tools-SLE-15-x86_64-Update.repo
    - source: salt://default/repos.d/SLE-Manager-Tools-SLE-15-x86_64-Update.repo
    - template: jinja

{% if 'released' in grains.get('version') | default('released', true) %}

tools_devel_repo:
  file.touch:
    - name: /tmp/no_tools_devel_repo_needed

{% elif 'nightly' in grains.get('version') | default('', true) %}

tools_devel_repo:
  file.managed:
    - name: /etc/zypp/repos.d/Devel_Galaxy_Manager_3.1_SLE-Manager-Tools-15-x86_64.repo
    - source: salt://default/repos.d/Devel_Galaxy_Manager_3.1_SLE-Manager-Tools-15-x86_64.repo
    - template: jinja

{% elif ('head' in grains.get('version') | default('', true)) or ('test' in grains.get('version') | default('', true)) %}
tools_devel_repo:
  file.managed:
    - name: /etc/zypp/repos.d/Devel_Galaxy_Manager_Head_SLE-Manager-Tools-15-x86_64.repo
    - source: salt://default/repos.d/Devel_Galaxy_Manager_Head_SLE-Manager-Tools-15-x86_64.repo
    - template: jinja

{% endif %}
{% endif %}


allow_vendor_changes:
  {% if grains['osfullname'] == 'Leap' %}
  file.managed:
    - name: /etc/zypp/vendors.d/opensuse
    - makedirs: True
    - contents: |
        [main]
        vendors = openSUSE,openSUSE Build Service,obs://build.suse.de/Devel:Galaxy,obs://build.opensuse.org
  {% else %}
  file.managed:
    - name: /etc/zypp/vendors.d/suse
    - makedirs: True
    - contents: |
        [main]
        vendors = SUSE,openSUSE Build Service,obs://build.suse.de/Devel:Galaxy,obs://build.opensuse.org
  {% endif %}

refresh_default_repos:
  cmd.run:
    - name: zypper --non-interactive --gpg-auto-import-keys refresh
    - require:
      - file: os_pool_repo
      - file: os_update_repo
      - file: tools_pool_repo
      - file: tools_update_repo
      - file: tools_devel_repo
{% endif %}

{% if grains['os_family'] == 'RedHat' %}

galaxy_key:
  file.managed:
    - name: /tmp/galaxy.key
    - source: salt://default/gpg_keys/galaxy.key
  cmd.wait:
    - name: rpm --import /tmp/galaxy.key
    - watch:
      - file: galaxy_key

{% if grains['osmajorrelease'] == '7' %}
tools_pool_repo:
  file.managed:
    - name: /etc/yum.repos.d/SLE-Manager-Tools-RES-7-x86_64.repo
    - source: salt://default/repos.d/SLE-Manager-Tools-RES-7-x86_64.repo
    - template: jinja
    - require:
      - cmd: galaxy_key

suse_res7_key:
  file.managed:
    - name: /tmp/suse_res7.key
    - source: salt://default/gpg_keys/suse_res7.key
  cmd.wait:
    - name: rpm --import /tmp/suse_res7.key
    - watch:
      - file: suse_res7_key

{% if 'head' in grains.get('version') | default('', true) %}
tools_update_repo:
  file.managed:
    - name: /etc/yum.repos.d/Devel_Galaxy_Manager_Head_RES-Manager-Tools-7-x86_64.repo
    - source: salt://default/repos.d/Devel_Galaxy_Manager_Head_RES-Manager-Tools-7-x86_64.repo
    - template: jinja
    - require:
      - cmd: galaxy_key
{% elif '3.0-nightly' in grains.get('version') | default('', true) %}
tools_update_repo:
  file.managed:
    - name: /etc/yum.repos.d/Devel_Galaxy_Manager_3.0_RES-Manager-Tools-7-x86_64.repo
    - source: salt://default/repos.d/Devel_Galaxy_Manager_3.0_RES-Manager-Tools-7-x86_64.repo
    - template: jinja
    - require:
      - cmd: galaxy_key
{% elif 'nightly' in grains.get('version') | default('', true) %}
tools_update_repo:
  file.managed:
    - name: /etc/yum.repos.d/Devel_Galaxy_Manager_3.1_RES-Manager-Tools-7-x86_64.repo
    - source: salt://default/repos.d/Devel_Galaxy_Manager_3.1_RES-Manager-Tools-7-x86_64.repo
    - template: jinja
    - require:
      - cmd: galaxy_key
{% endif %}
{% endif %}

{% endif %}

default_repos:
  test.nop: []
