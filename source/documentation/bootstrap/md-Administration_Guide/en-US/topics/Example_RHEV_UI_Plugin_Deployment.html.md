# Example User Interface Plug-in Deployment

Follow these instructions to create a user interface plug-in that runs a `Hello World!` program when you sign in to the Red Hat Virtualization Manager administration portal.

**Deploying a `Hello World!` Plug-in**

1. Create a plug-in descriptor by creating the following file in the Manager at `/usr/share/ovirt-engine/ui-plugins/helloWorld.json`:

        {
            "name": "HelloWorld",
            "url": "/ovirt-engine/webadmin/plugin/HelloWorld/start.html",
            "resourcePath": "hello-files"
        }

2. Create the plug-in host page by creating the following file in the Manager at `/usr/share/ovirt-engine/ui-plugins/hello-files/start.html`:

        <!DOCTYPE html><html><head>
        <script>
            var api = parent.pluginApi('HelloWorld');
            api.register({
         UiInit: function() { window.alert('Hello world'); }
            });
            api.ready();
        </script>
        </head><body></body></html>

If you have successfully implemented the `Hello World!` plug-in, you will see this screen when you sign in to the administration portal:

**A Successful Implementation of the `Hello World!` Plug-in**

![](images/1475.png)
