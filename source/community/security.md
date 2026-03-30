---
title: Security
category: security
authors:
  - djorm
  - quaid
  - sandrobonazzola
---

## oVirt Security Policy

The oVirt project takes security seriously. As a community-led project, we rely on coordinated disclosure to protect our users.

### Reporting a Vulnerability

**Please do not open a public GitHub issue for security vulnerabilities.**

To report a security issue, please use the **"Report a vulnerability"** button located under the **Security** tab of the relevant repository.

This will initiate a private conversation with the oVirt Security Managers. Using this method allows us to:

1. Triage the issue privately.
2. Collaborate on a fix in a secure environment.
3. Coordinate a public disclosure and CVE assignment.

### Supported Versions

The oVirt community will fix only issues related to [the most recent released version](https://ovirt.org/download/).

### Our Process

* **Acknowledgement:** We aim to acknowledge receipt of your report as soon as possible.
* **Triage:** We will investigate and notify you if the report is accepted as a vulnerability.
* **Fix & Disclosure:** We follow a 90-day disclosure policy, but we aim to release fixes as quickly as possible.

### New issues in oVirt vs. vulnerabilities in other projects {#new-issues-in-ovirt-vs-vulnerabilities-in-other-projects}

The private reporting flow and Security Manager checklist below focus on **new, not-yet-public vulnerability reports in oVirt's own code**,
including requesting a CVE when appropriate.

If someone reports that oVirt is affected by a problem **in another project** oVirt depends on:

* **Already public:** You do **not** need a new oVirt-specific CVE.
  Assess impact on oVirt, validate fixes, and communicate to the community using the **existing CVE ID** (and upstream references as needed).
* **Not yet publicly disclosed:** Coordinate with the **maintainers of the vulnerable project** so that oVirt does not publish details
  before the agreed disclosure time, and so announcements use the **correct CVE ID**.
  CVE reservation and assignment are handled by the **CNA for that upstream project**, not as a separate oVirt-only CVE.

The steps that follow (private advisory, embargo, **Request CVE** in GitHub) apply to **undisclosed issues in oVirt code**.
Impact assessment, fix validation, and community disclosure still apply in all cases.

### Security advisories

The security advisories are visible in the **Security** tab of the relevant repository.

## oVirt Security Manager Checklist

1. Intake & Triage (The First 72 Hours)
   * [ ] **Review Report**:
     * When a report arrives via Private Vulnerability Reporting, you will receive a notification.
     * Open it in the repo’s *Security* > *Advisories* tab.
   * [ ] **Verify & Lock**:
     * Confirm the bug is valid.
     * Once verified, use the "Lock advisory" feature (new in 2026) to prevent the reporter or non-admins from changing the metadata (severity, affected versions) while you work.
   * [ ] **Assign Severity**:
     * Use the built-in CVSS calculator to set the severity (Low, Moderate, High, Critical).

2. Collaborative Fix (The Embargo Period)
   * [ ] **Create Temporary Private Fork**:
     * Inside the advisory, click "Create temporary private fork." This creates a hidden sandbox.
   * [ ] **Invite Developers**:
     * Add specific oVirt maintainers to the advisory.
       {{site.data.alerts.important}}
       Only invite the minimum number of people needed to fix the bug to maintain the embargo.
       {{site.data.alerts.end}}
   * [ ] **The CI Workaround**:
     * As of early 2026, GitHub Actions often do not run by default on temporary private forks for safety.
     * **Manual Step**: You may need to manually trigger a local build/test or create a separate private repository within
       the oVirt organization for extensive CI testing if the private fork's limitations hinder you.
   * [ ] **Request CVE** (for **new** vulnerabilities in oVirt code):
     * Click the "Request CVE ID" button. GitHub (acting as the CNA) will usually assign a CVE-YEAR-XXXXX identifier within 24–48 hours. Keep this draft.
       {{site.data.alerts.important}}
       Skip this when the issue is already covered by a CVE from another project;
       reference that CVE in advisories and community communication instead
       (see [New issues in oVirt vs. vulnerabilities in other projects](#new-issues-in-ovirt-vs-vulnerabilities-in-other-projects) above).
       {{site.data.alerts.end}}

3. Downstream Pre-Notification (1–2 Weeks before Release)

   * [ ] **Identify Stakeholders**:
     * Identify 1–2 trusted security contacts for each major distribution that packages oVirt.
   * [ ] **Invite to Advisory**:
     * Add their GitHub usernames to the Advisory Collaborators. This allows them to see the fix and prepare their packages while the issue is still under embargo.
   * [ ] **Coordinate the "Ship Date"**:
     * Agree on a specific date and time (UTC) for the public disclosure so everyone can release patches simultaneously.

4. Publication & Disclosure

   * [ ] **Merge the Fix**:
     * Once the fix is ready, the private fork will be merged into the main branch only when the advisory is published.
   * [ ] **Publish Advisory**:
     * Click "Publish advisory." This:
       * Makes the fix public.
       * Updates the Global GitHub Advisory Database.
       * Triggers Dependabot alerts for any projects using oVirt as a dependency.
       * Automatically notifies the CVE Project to move the CVE from "Reserved" to "Published."

   * [ ] **Announce**:
     * Send a final email to <users@ovirt.org> and <devel@ovirt.org> with the CVE link and a "thank you" to the researcher.

### How to Handle the "CI Gap"

If your GitHub Actions workflows are complex and must run to verify the fix, the community standard is:

* Create a Private Repository named ovirt-security-staging.
* Push the fix there and run your full CI suite.
* Once green, copy the patch back to the Temporary Private Fork for the final GitHub-managed merge.
