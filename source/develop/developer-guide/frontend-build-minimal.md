---
title: Frontend build minimal
authors: lhornyak
---

# Frontend build minimal

## A minimal frontend build

You can use [jrebel](/develop/developer-guide/java/backend-with-jrebel.html) to avoid frequent rebuild and redeploy, which is really time-consuming. However in some cases (e.g. frontend code changes) you have to rebuild. This is how you can do it relatively quick:

      mvn clean install -up -e -Pgwt-admin,jrebel,dep -DskipTests=true -Dgwt.userAgent=gecko1_8 -Dgwt.draftCompile=true -Dgwt.compiler.localWorkers=1 -Dgwt.logLevel=INFO

With any luck, this can run on just 4 GB of RAM.
