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
{%- if 'container' in pillar['ses'] and 'ceph' in pillar['ses']['container']['images'] %}
        CEPH_DAEMON_IMAGE={{ pillar['ses']['container']['images']['ceph'] }} \
{%- endif %}
        ceph-daemon --verbose bootstrap --mon-ip {{ grains['fqdn_ip4'][0] }} \
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
        ceph config-key set mgr/ssh/ssh_identity_key -i ~/.ssh/id_rsa
        ceph config-key set mgr/ssh/ssh_identity_pub -i ~/.ssh/id_rsa.pub
        ceph mgr module enable ssh && \
        ceph orchestrator set backend ssh && \
{% for minion in pillar['ses']['minions'] %}
        ceph orchestrator host add {{ minion }} && \
{% endfor %}
        true
    - onchanges:
      - cmd: run ceph-daemon bootstrap
{% endif %}