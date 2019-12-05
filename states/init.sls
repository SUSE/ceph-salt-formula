{% if 'ses' in grains and grains['ses']['member'] %}

include:
    - .software
    - .apparmor
    - .sshkey
    - .time
{% if pillar['ses'].get('deploy', {'bootstrap': True}).get('bootstrap', True) %}
    - .cephbootstrap
{% endif %}
{% if grains['id'] == pillar['ses']['bootstrap_mon'] %}
{% if pillar['ses'].get('deploy', {'mon': False}).get('mon', False) %}
    - .ceph-mon
{% endif %}
{% if pillar['ses'].get('deploy', {'mgr': False}).get('mgr', False) %}
    - .ceph-mgr
{% endif %}
{% if pillar['ses'].get('deploy', {'osd': False}).get('osd', False) %}
    - .ceph-osd
{% endif %}
{% endif %}

{% else %}

nothing to do in this node:
  test.nop

{% endif %}