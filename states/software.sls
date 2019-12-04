{% if pillar['ses'].get('upgrades', {'enabled': False})['enabled'] %}

upgrade packages:
  module.run:
    - name: pkg.upgrade

{% else %}

upgrades disabled:
  test.nop

{% endif %}
