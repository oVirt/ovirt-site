---
title: Migration from vdscli to jsonrpcvdscli
authors: pkliczewski
---

# Migration from vdscli to jsonrpcvdscli

Between both communication modules there is a compatibility issue. When we work with jsonrpc we do not send response status information (code, message) when method invocation was successful. We only send it when command failed. There is compatibility mode that we can set when calling jsonrpcvdscli.connect.

## vdscli

Here is the code how we used to create vdscli client:

      hostPort = vdscli.cannonizeHostPort(
          self._dst,
          config.getint('addresses', 'management_port'))
      if config.getboolean('vars', 'ssl'):
          self._destServer = vdscli.connect(hostPort,
              useSSL=True,
              TransportClass=kaxmlrpclib.TcpkeepSafeTransport)
      else:
          destServer = kaxmlrpclib.Server('`[`http://`](http://)`' + hostPort)

In the old code we provide information where we want to connect in hostPort and whether we want to use ssl.

## jsonrpcvdscli

Here is jsonrpcvdscli code:
      from vdsm import jsonrpcvdscli
      from vdsm.config import config 
      requestQueues = config.get('addresses', 'request_queues')
      requestQueue = requestQueues.split(",")[0]
      destServer = jsonrpcvdscli.connect(requestQueue, host=host, port=port)

Above code use config.py to get missing information we can customize the client by providing more detail:

      from vdsm import jsonrpcvdscli
      from vdsm.config import config
      from vdsm.sslcompat import sslutils
      from vdsm import utils
      sslctx = sslutils.create_ssl_context()
      client_socket = utils.create_connected_socket(host, int(port), sslctx)
      client = clientIF.createStompClient(client_socket)
      requestQueues = config.get('addresses', 'request_queues')
      requestQueue = requestQueues.split(",")[0]
      destServer = jsonrpcvdscli.connect(requestQueue, client) 

Please note that above code do not connect during the process of creation. It is required to call a procedure to physically establish connection.

New client is not widely used so for some of the methods it is required to update _COMMAND_CONVERTER dictionary in jsonrpcvdscli module. It contain mapping of a methods called on destServer proxy object and api method names.

## example

There are 2 examples in vdsm code already:

*   migration.py
*   tests/functional/utils.py
