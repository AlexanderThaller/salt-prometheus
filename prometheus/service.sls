{% from 'prometheus/map.jinja' import lookup %}

prometheus.service:
  service.running:
    - name: {{ lookup.service }}
    - enable: True
    - reload: True
    - require:
      - file: 'prometheus.binary'
      - file: 'prometheus.rc_file'
    - watch:
      - file: 'prometheus.config'
      - file: 'prometheus.config.rc'
