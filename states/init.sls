{% if 'ses' in grains and grains['ses']['member'] %}

include:
    - .software
    - .apparmor
    - .sshkey
    - .time
    - .cephbootstrap
{% if pillar['ses'].get('deploy', {'mon': False}).get('mon', False) %}
    - .ceph-mon
{% endif %}

{% else %}

nothing to do in this node:
  test.nop

{% endif %}