# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.1.x   | :white_check_mark: |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

We take security vulnerabilities seriously. If you discover a security vulnerability, please follow these steps:

### 1. Do NOT create a public issue

Please do not report security vulnerabilities through public GitHub issues.

### 2. Report privately

Send an email to: **25517637+uldyssian-sh@users.noreply.github.com**

Include the following information:
- Description of the vulnerability
- Steps to reproduce the issue
- Potential impact
- Suggested fix (if any)

### 3. Response timeline

- **Initial response**: Within 48 hours
- **Status update**: Within 7 days
- **Fix timeline**: Depends on severity (see below)

## Severity Levels

### Critical (Fix within 24-48 hours)
- Remote code execution
- Privilege escalation
- Data exposure

### High (Fix within 1 week)
- Authentication bypass
- Significant data leakage
- DoS vulnerabilities

### Medium (Fix within 2 weeks)
- Information disclosure
- CSRF vulnerabilities
- Input validation issues

### Low (Fix within 1 month)
- Minor information leaks
- Non-exploitable issues

## Security Best Practices

### For Users
1. **Always validate vCenter certificates** in production
2. **Use least privilege accounts** for vCenter connections
3. **Run scripts in isolated environments** when possible
4. **Keep PowerCLI updated** to latest version
5. **Review audit results** before sharing

### For Contributors
1. **Never commit credentials** or sensitive data
2. **Use parameterized queries** and input validation
3. **Follow secure coding practices**
4. **Test security controls** thoroughly
5. **Document security assumptions**

## Security Features

### Built-in Security Controls
- **Read-only operations** - Script never modifies VM configurations
- **Input validation** - All parameters are validated
- **Error handling** - Graceful failure without information disclosure
- **Credential protection** - No credentials stored in code
- **Audit logging** - All operations are logged

### PowerShell Security
- **Execution policy** compliance
- **Script signing** support (when available)
- **PowerShell constrained language mode** compatible
- **No dynamic code execution**

## Compliance

This tool is designed to help with:
- **DoD STIG** compliance auditing
- **Security baseline** validation
- **Vulnerability assessment**
- **Configuration management**

## Security Scanning

Automated security scans run:
- On every commit (SAST)
- Weekly (dependency scan)
- On pull requests (security review)

Tools used:
- **Trivy** - Vulnerability scanning
- **PSScriptAnalyzer** - PowerShell security analysis
- **TruffleHog** - Secret detection
- **CodeQL** - Static analysis

## Responsible Disclosure

We follow responsible disclosure practices:
1. Vulnerabilities are fixed before public disclosure
2. Credit is given to security researchers
3. Timeline is coordinated with reporter
4. Public advisory is published after fix

## Contact

For security-related questions:
- **Security issues**: 25517637+uldyssian-sh@users.noreply.github.com
- **General questions**: [GitHub Issues](https://github.com/uldyssian-sh/vmware-vm-audit-dod-stig/issues)
- **Discussions**: [GitHub Discussions](https://github.com/uldyssian-sh/vmware-vm-audit-dod-stig/discussions)# Updated Sun Nov  9 12:49:29 CET 2025
# Updated Sun Nov  9 12:52:36 CET 2025
