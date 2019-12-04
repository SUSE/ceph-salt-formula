install ceph-daemon:
  pkg.installed:
    - pkgs:
        - ceph-daemon

{% if 'mon' in grains['ses']['roles'] %}
        - ceph-common
{% endif %}

{% if grains['id'] == pillar['ses']['bootstrap_mon'] %}
/var/log/ceph:
  file.directory:
    - user: ceph
    - group: ceph
    - mode: 0770
    - makedirs: True

run ceph-daemon bootstrap:
  cmd.run:
    - name: |
        ceph-daemon --verbose bootstrap --mon-ip {{ grains['fqdn_ip4'][0] }} \
{%- if 'container' in pillar['ses'] and 'ceph' in pillar['ses']['container']['images'] %}
                    --image {{ pillar['ses']['container']['images']['ceph'] }} \
{%- endif %}
                    --initial-dashboard-user admin \
                    --initial-dashboard-password admin \
                    --output-keyring /etc/ceph/ceph.client.admin.keyring \
                    --output-config /etc/ceph/ceph.conf \
                    --skip-ssh > /var/log/ceph/ceph-daemon.log 2>&1
    - creates:
      - /etc/ceph/ceph.conf
      - /etc/ceph/ceph.client.admin.keyring

configure ssh orchestrator:
  cmd.run:
    - name: |
        ceph mgr module enable ssh && \
        ceph orchestrator set backend ssh && \
{% for minion in pillar['ses']['minions'] %}
        ceph orchestrator host add {{ minion }} && \
{% endfor %}
        true
    - onchanges:
      - cmd: run ceph-daemon bootstrap
{% endif %}