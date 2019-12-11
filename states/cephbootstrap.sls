install ceph-daemon:
  pkg.installed:
    - pkgs:
        - ceph-daemon

{% if 'mon' in grains['ceph-salt']['roles'] %}
        - ceph-common
{% endif %}

{% if 'container' in pillar['ceph-salt'] and 'ceph' in pillar['ceph-salt']['container']['images'] %}
download ceph container image:
  cmd.run:
    - name: |
        podman pull {{ pillar['ceph-salt']['container']['images']['ceph'] }}
{% endif %}

{% if grains['id'] == pillar['ceph-salt']['bootstrap_mon'] %}
/var/log/ceph:
  file.directory:
    - user: ceph
    - group: ceph
    - mode: '0770'
    - makedirs: True

{% set dashboard_username = pillar['ceph-salt'].get('dashboard', {'username': 'admin'}).get('username', 'admin') %}

run ceph-daemon bootstrap:
  cmd.run:
    - name: |
{%- if 'container' in pillar['ceph-salt'] and 'ceph' in pillar['ceph-salt']['container']['images'] %}
        CEPH_DAEMON_IMAGE={{ pillar['ceph-salt']['container']['images']['ceph'] }} \
{%- endif %}
        ceph-daemon --verbose bootstrap --mon-ip {{ grains['fqdn_ip4'][0] }} \
                    --initial-dashboard-user {{ dashboard_username }} \
                    --output-keyring /etc/ceph/ceph.client.admin.keyring \
                    --output-config /etc/ceph/ceph.conf \
                    --skip-ssh > /var/log/ceph/ceph-daemon.log 2>&1
    - creates:
      - /etc/ceph/ceph.conf
      - /etc/ceph/ceph.client.admin.keyring

{% set dashboard_password = pillar['ceph-salt'].get('dashboard', {'password': None}).get('password', None) %}
{% if dashboard_password %}
set ceph-dashboard password:
  cmd.run:
    - name: |
        ceph dashboard ac-user-set-password --force-password admin {{ dashboard_password }}
    - onchanges:
      - cmd: run ceph-daemon bootstrap
{% endif %}

configure ssh orchestrator:
  cmd.run:
    - name: |
        ceph config-key set mgr/ssh/ssh_identity_key -i ~/.ssh/id_rsa
        ceph config-key set mgr/ssh/ssh_identity_pub -i ~/.ssh/id_rsa.pub
        ceph mgr module enable ssh && \
        ceph orchestrator set backend ssh && \
{% for minion in pillar['ceph-salt']['minions']['all'] %}
        ceph orchestrator host add {{ minion }} && \
{% endfor %}
        true
    - onchanges:
      - cmd: run ceph-daemon bootstrap
{% endif %}