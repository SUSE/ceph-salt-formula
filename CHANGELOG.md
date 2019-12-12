# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Changed
- Rename ceph-daemon to cephadm
- Rename mgr/ssh module to mgr/cephadm

## [0.1.0] - 2019-12-12
### Added
- Use ceph daemon container image from image path stored in the pillar
- ceph-dashboard credentials configuration
- Automatic SSH orchestrator configuration:
  - Enbales SSH orchestrator and adds hosts
- ceph-mon deployment
- ceph-mgr deployment
- ceph-osd deployment based on drive groups specification stored in the pillar

## [0.0.1] - 2019-12-03
### Added
- Salt state files for:
    - SSH key distribution
    - chrony setup
    - preliminary apparmor configuration
    - packages updates
    - preliminary ceph-deamon bootstrap execution
- RPM spec file.
- Minimal README.

[Unreleased]: https://github.com/SUSE/ceph-bootstrap/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/SUSE/ceph-bootstrap/releases/tag/v0.1.0
[0.0.1]: https://github.com/SUSE/ceph-bootstrap/releases/tag/v0.0.1
