{% from 'prometheus/map.jinja' import lookup %}
{% set datamap = salt['pillar.get']('consul') %}

prometheus.config:
  file.managed:
    - name: '{{ salt['file.join'](lookup.etc_path, 'prometheus') }}'
    - source: 'salt://prometheus/files/config'
    - template: 'jinja'

{% if salt['grains.get']('os_family') == 'FreeBSD' %}
prometheus.config.rc:
  file.blockreplace:
    - name: '/etc/rc.conf'
    - marker_start: "# START - prometheus"
    - marker_end: "# END - prometheus"
    - append_if_not_found: True
    - content: |
        # MANAGED BY SALT DO NOT EDIT
        prometheus_storage_local_retention="{{ salt['pillar.get']('prometheus:retention', '360h0m0s') }}"
{% endif %}

{% if salt['pillar.get']('consul') is defined %}
prometheus.consul_service:
  file.managed:
    - name: '{{ salt['file.join'](lookup.consul_service_path, "prometheus.json") }}'
    - source: 'salt://prometheus/files/consul.json'
{% endif %}
