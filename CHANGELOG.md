# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Comprehensive test suite with unit and integration tests
- CI/CD pipeline with GitHub Actions
- Advanced usage examples and automation scripts
- Wiki documentation with detailed guides
- Security policy and vulnerability reporting process
- Code of conduct for contributors
- Issue and pull request templates

### Changed
- Enhanced README with better documentation structure
- Improved error handling and logging
- Updated PowerCLI compatibility requirements

### Fixed
- Minor bug fixes in device detection logic

## [1.1.0] - 2024-01-15

### Added
- Support for VM templates auditing with `-IncludeTemplates` parameter
- Enhanced encryption status detection for VM home and disk encryption
- Additional device security checks (serial ports, parallel ports, floppy drives)
- Comprehensive compliance reporting with detailed non-compliance reasons
- Support for PowerShell 7+ cross-platform compatibility

### Changed
- Improved output formatting with cleaner table display
- Enhanced advanced settings validation logic
- Better error handling for vCenter connectivity issues
- Updated DoD STIG compliance checks to latest standards

### Fixed
- Fixed issue with vTPM detection on certain VM configurations
- Resolved PowerCLI module loading warnings
- Corrected EFI Secure Boot status detection

### Security
- Added input validation for all parameters
- Improved credential handling through PowerCLI
- Enhanced error messages to prevent information disclosure

## [1.0.0] - 2023-12-01

### Added
- Initial release of VMware VM DoD STIG Audit Tool
- Core functionality for VM security compliance auditing
- Support for vSphere 8.0 environments
- PowerCLI integration for VMware API access
- Basic console data movement restriction checks
- Firmware and Secure Boot validation
- VNC access control verification
- VM encryption status reporting

### Features
- Read-only operation ensuring no modifications to VMs
- Batch processing of multiple VMs
- Single VM targeted auditing
- Comprehensive compliance status reporting
- PowerShell native integration

### Requirements
- PowerShell 5.1 or higher
- VMware PowerCLI 13.0+
- vCenter Server access with read permissions

---

## Release Notes

### Version 1.1.0 Highlights
This release significantly expands the audit capabilities with enhanced device security checks, improved encryption detection, and better compliance reporting. The tool now provides more detailed insights into VM security posture with comprehensive non-compliance reason tracking.

### Version 1.0.0 Highlights
The initial release provides core DoD STIG compliance auditing for VMware virtual machines. This version establishes the foundation for automated security compliance checking in vSphere environments with read-only operations and comprehensive reporting.

## Upgrade Instructions

### From 1.0.x to 1.1.x
1. Download the latest release
2. Replace the existing script file
3. No configuration changes required
4. New parameters are optional and backward compatible

## Breaking Changes

### Version 1.1.0
- No breaking changes from version 1.0.x
- All existing scripts and automation will continue to work

## Deprecation Notices

### Future Versions
- PowerShell 5.1 support will be maintained through 2024
- PowerCLI versions below 13.0 will not be supported in future releases

## Contributors

Special thanks to all contributors who helped make these releases possible:
- Community feedback and bug reports
- Feature suggestions and enhancement requests
- Documentation improvements
- Testing and validation efforts

---

For more detailed information about each release, visit the [GitHub Releases](https://github.com/uldyssian-sh/vmware-vm-audit-dod-stig/releases) page.# Updated 20251109_123831
