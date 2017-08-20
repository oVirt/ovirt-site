---
title: oVirt Webadmin GWT Debug Quick Refresh
author: gshereme
tags: GWT, webadmin, debugging
date: 2017-08-04 15:00:00 CET
comments: true
published: true
---

As a developer, one drawback of using Google Web Toolkit (GWT) for the oVirt Administration Portal (aka webadmin) is that the GWT compile process takes an exceptionally long time. If you make a change in some code and rebuild the ovirt-engine project using `make install-dev ...`, you'll be waiting several minutes to test your change. In practice, such a long delay in the usual code-compile-refresh-test cycle would be unbearable.

READMORE

Luckily, we can use GWT Super Dev Mode ("SDM") to start up a quick refresh-capable instance of the application. With SDM running, you can make a change in GWT and test the refreshed change within seconds.

If you want to step through code and use the Chrome debugger, oVirt and SDM don't work well together for debugging due to the oVirt Administration Portal's code and source map size. Therefore, below we demonstrate how to disable source maps.

## Demo (40 seconds)

<a href="http://www.youtube.com/watch?feature=player_embedded&v=IRGxIrwfnlo
    " target="_blank"><img src="http://img.youtube.com/vi/IRGxIrwfnlo/0.jpg"
    alt="demo" width="480" height="360" border="10" /></a>

## Steps

1. Open a terminal, build the engine normally, and start it.

    ```
    make clean install-dev PREFIX=$HOME/ovirt-engine DEV_EXTRA_BUILD_FLAGS_GWT_DEFAULTS="-Dgwt.cssResourceStyle=pretty -Dgwt.userAgent=safari" BUILD_UT=0 DEV_EXTRA_BUILD_FLAGS="-Dgwt.compiler.localWorkers=1"

    ...

    $HOME/ovirt-engine/share/ovirt-engine/services/ovirt-engine/ovirt-engine.py start

    ```

    ![screen](../images/blog/2017-08-04/1.png)

    ![screen](../images/blog/2017-08-04/2.png)

    ![screen](../images/blog/2017-08-04/3.png)

2. In a second terminal, run:

    Chrome:

    ```
    make gwt-debug DEV_BUILD_GWT_SUPER_DEV_MODE=1 DEV_EXTRA_BUILD_FLAGS_GWT_DEFAULTS="-Dgwt.userAgent=safari"
    ```

    or

    Firefox:

    ```
    make gwt-debug DEV_BUILD_GWT_SUPER_DEV_MODE=1 DEV_EXTRA_BUILD_FLAGS_GWT_DEFAULTS="-Dgwt.userAgent=gecko1_8"
    ```

    ![screen](../images/blog/2017-08-04/4.png)

    Wait about two minutes until "code server running at http://<>:9876/" displays, and then the GWT Dev Mode app will open.

    ![screen](../images/blog/2017-08-04/5.png)

3.  Open your browser and go to http://localhost:9876/ **You must use localhost. The procedure breaks with IPs.*

    Now you'll see two buttons, Dev Mode On and Dev Mode Off.

    ![screen](../images/blog/2017-08-04/6.png)

    Drag those buttons to the browser bookmark bar, as it says on that page.

    ![screen](../images/blog/2017-08-04/7.png)

4. Ignore the link under the two buttons. Instead, open another browser window and enter http://localhost:8080 in the address bar to go to webadmin.

    ![screen](../images/blog/2017-08-04/8.png)

5. Log in and navigate to the Administration Portal.

6. [Chrome only] Press F12 and click the hamburger menu, followed by Settings. Disable both JavaScript and CSS source maps. The Administration Portal is too large and the source maps crash Chrome.

    ![screen](../images/blog/2017-08-04/9.png)

    ![screen](../images/blog/2017-08-04/10.png)

    ![screen](../images/blog/2017-08-04/11.png)

7. Click Dev Mode On

    ![screen](../images/blog/2017-08-04/12.png)

8. Drag the Compile button to your bookmarks bar

    ![screen](../images/blog/2017-08-04/13.png)

9. Click Compile

    ![screen](../images/blog/2017-08-04/14.png)

    The first compilation is slow, taking up to two minutes.

10. Make a change to the GWT code. Here I am creating a new "About" dialog box that has an image as a background. I will tweak the font properties of the dialog's Close button to demonstrate the refresh.

    Before:

    ![screen](../images/blog/2017-08-04/15.png)

    ![screen](../images/blog/2017-08-04/16.png)

    Change:

    ![screen](../images/blog/2017-08-04/17.png)

    Let's test.

11. Click Compile. Make sure it says "On". If it doesn't, did you use localhost above?

    ![screen](../images/blog/2017-08-04/18.png)

    ![screen](../images/blog/2017-08-04/19.png)

    In the second terminal, you will see:

    ```
      Link succeeded
      [INFO]          Linking succeeded -- 3.654s
      [INFO]       7.537s total -- Compile completed
    ```

The browser should refresh, and the app will now display the change.
    ![screen](../images/blog/2017-08-04/20.png)
