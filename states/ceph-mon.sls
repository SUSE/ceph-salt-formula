{% if pillar['ses']['minions']['mon'] | length > 1 %}
{% set mon_update_args = [pillar['ses']['minions']['mon'] | length | string] %}
{% for minion, ip in pillar['ses']['minions']['mon'].items() %}
{% if minion != grains['id'] %}
{% if mon_update_args.append(minion + ":" + ip) %}{% endif %}
{% endif %}
{% endfor %}

deploy remaining mons:
  cmd.run:
    - name: |
        ceph orchestrator mon update {{ mon_update_args | join(' ') }}

{% endif %}
