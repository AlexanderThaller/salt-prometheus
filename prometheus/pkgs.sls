{% from 'prometheus/map.jinja' import lookup %}

prometheus.tarball:
  archive.extracted:
    - name: '{{ salt['file.join'](lookup.opt_path, 'prometheus') }}'
    - source: 'salt://prometheus/files/binary/{{ salt['grains.get']('os_family') }}/{{ lookup.tarball_name }}.tar.gz'
    - archive_format: tar

prometheus.binary:
  file.symlink:
    - name: '{{ salt['file.join'](lookup.bin_path, 'prometheus') }}'
    - target: '{{ salt['file.join'](lookup.opt_path, 'prometheus', lookup.tarball_name, 'prometheus') }}'
    - force: True

prometheus.rc_file:
  file.managed:
    - name: '{{ salt['file.join'](lookup.rc_path, 'prometheus') }}'
    - source: 'salt://prometheus/files/rc.FreeBSD'
    - mode: '0755'

prometheus.group:
  group.present:
    - name: 'prometheus'
    - system: True
    - gid: '553'

prometheus.user:
  user.present:
    - name: 'prometheus'
    - fullname: 'Prometheus Daemon'
    - home: '/var/db/prometheus'
    - shell: '/usr/sbin/nologin'
    - uid: '553'
    - gid: '553'
