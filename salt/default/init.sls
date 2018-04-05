include:
  - default.repos
  {% if grains['hostname'] and grains['domain'] %}
  - default.hostname
  {% endif %}
  {% if grains['use_avahi'] %}
  - default.avahi
  {% endif %}
  {% if grains.get('reset_ids') | default(false, true) %}
  - default.ids
  {% endif %}

minimal_package_update:
  pkg.latest:
    - pkgs:
      - salt
      - salt-minion
{% if grains['os_family'] == 'Suse' %}
      - zypper
      - libzypp
{% endif %}
    - order: last
    - require:
      - sls: default.repos

{% if grains.get('use_unreleased_updates') | default(False, true) %}
update_sles_test:
  pkg.uptodate
{% endif %}

{% if grains['authorized_keys'] %}
authorized_keys:
  file.append:
    - name: /root/.ssh/authorized_keys
    - text:
{% for key in grains['authorized_keys'] %}
      - {{ key }}
{% endfor %}
    - makedirs: True
{% endif %}
