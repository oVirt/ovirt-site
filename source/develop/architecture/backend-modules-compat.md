---
title: Backend modules compat
category: architecture
authors: amuller
---

# Backend modules compat

compat (Meaning compatibility) stems from the previous iteration in oVirt's life. oVirt (Then Solid Ice) was originally written in C#. Following Redhat's 2008 purchase of Qumranet, the engine was re-written in Java. The compatibility module fills in the gaps of Java, as the re-write originally targeted Java 5 which lacked several features then existing in C#. The compat module is essentially a collection of utility classes that exist in C# and do not in Java.

**Examples:**

*   TimeSpan
*   DateTime
*   Event and EventArgs

**Deprecation:** Many of these classes have been deprecated since the re-write, and recommended classes are to be used instead.
StringHelper, for example, is to be avoided and [org.apache.commons.lang.StringUtils](http://commons.apache.org/proper/commons-lang/javadocs/api-2.3/org/apache/commons/lang/StringUtils.html) used instead.
