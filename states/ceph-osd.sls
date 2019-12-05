{% set dg_list = pillar['ses'].get('storage', {'drive_groups': []}).get('drive_groups', []) %}
{% for dg_spec in dg_list %}

deploy ceph osds ({{ loop.index }}/{{ dg_list | length }}):
  cmd.run:
    - name: |
        echo '{{ dg_spec }}' | ceph orchestrator osd create -i -

{% endfor %}
