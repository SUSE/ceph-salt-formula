{% if 'ses' in grains and grains['ses']['member'] %}

include:
    - .software
    - .apparmor
    - .sshkey
    - .time
    - .cephbootstrap

{% else %}

nothing to do in this node:
  test.nop

{% endif %}