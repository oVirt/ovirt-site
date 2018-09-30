# Network Interface Metrics

The following types of metrics are reported from physical and virtual network interfaces on the host:

* Bytes (octets) transmitted and received (total, or per second)
* Packets transmitted and received (total, or per second)
* Interface errors (total, or per second)

The following table describes the network interface metrics reported by the *Interface* plugin.

**Network Interface Metrics**

<table>
<tr>
  <th>collectd.type</th>
  <th>Metric Name</th>
  <th>Description</th>
</tr>
<tr>
  <td>if_octets</td>
  <td>collectd.interface.if_octets.rx</td>
  <td>
    <p>A count of the bytes received by the interface. You can view this metric as a Rate/sec or a cumulative count (Max):</p>
    <ul>
      <li>Rate/sec: Provides the current traffic level on the interface in bytes/sec.</li>
      <li>Max: Provides the cumulative count of bytes received. Note that since this metric is a cumulative counter, its value will periodically restart from zero when the maximum possible value of the counter is exceeded.</li>
    </ul>
  </td>
</tr>
<tr>
  <td>if_octets</td>
  <td>collectd.interface.if_octets.tx</td>
  <td>
    <p>A count of the bytes transmitted by the interface. You can view this metric as a Rate/sec or a cumulative count (Max):</p>
    <ul>
      <li>Rate/sec: Provides the current traffic level on the interface in bytes/sec.</li>
      <li>Max: Provides the cumulative count of bytes transmitted. Note that since this metric is a cumulative counter, its value will periodically restart from zero when the maximum possible value of the counter is exceeded.</li>
    </ul>
  </td>
</tr>
<tr>
  <td>if_packets</td>
  <td>collectd.interface.if_packets.rx</td>
  <td>
    <p>A count of the packets received by the interface.</p>
    <p>You can view this metric as a Rate/sec or a cumulative count (Max):</p>
    <ul>
      <li>Rate/sec: Provides the current traffic level on the interface in bytes/sec.</li>
      <li>Max: Provides the cumulative count of packets received. Note that since this metric is a cumulative counter, its value will periodically restart from zero when the maximum possible value of the counter is exceeded. </li>
    </ul>
  </td>
</tr>
<tr>
  <td>if_packets</td>
  <td>collectd.interface.if_packets.tx</td>
  <td>
    <p>A count of the packets transmitted by the interface.</p>
    <p>You can view this metric as a Rate/sec or a cumulative count (Max):</p>
    <ul>
      <li>Rate/sec: Provides the current traffic level on the interface in packets/sec.</li>
      <li>Max: Provides the cumulative count of packets transmitted. Note that since this metric is a cumulative counter, its value will periodically restart from zero when the maximum possible value of the counter is exceeded. </li>
    </ul>
  </td>
</tr>
<tr>
  <td>if_errors</td>
  <td>collectd.interface.if_errors.rx</td>
  <td>
    <p>A count of errors received on the interface.</p>
    <p>You can view this metric as a Rate/sec or a cumulative count (Max).</p>
    <ul>
      <li>Rate/sec rollup provides the current rate of errors received on the interface in errors/sec.</li>
      <li>Max rollup provides the total number of errors received since the beginning. Note that since this is a cumulative counter, its value will periodically restart from zero when the maximum possible value of the counter is exceeded.</li>
    </ul>
  </td>
</tr>
<tr>
  <td>if_errors</td>
  <td>collectd.interface.if_errors.tx</td>
  <td>
    <p>A count of errors transmitted on the interface.</p>
    <p>You can view this metric as a Rate/sec or a cumulative count (Max).</p>
    <ul>
      <li>Rate/sec rollup provides the current rate of errors transmitted on the interface in errors/sec.</li>
      <li>Max rollup provides the total number of errors transmitted since the beginning. Note that since this is a cumulative counter, its value will periodically restart from zero when the maximum possible value of the counter is exceeded.</li>
    </ul>
  </td>
</tr>
<tr>
  <td>if_dropped</td>
  <td>collectd.interface.if_dropped.rx</td>
  <td></td>
</tr>
<tr>
  <td>if_dropped</td>
  <td>collectd.interface.if_dropped.tx</td>
  <td></td>
</tr>
</table>

**Additional Values**

* **collectd.plugin:** Interface
* **collectd.type_instance:** None
* **collectd.plugin_instance:** *The network's name*
* **ovirt.entity:** host
* **ovirt.cluster.name.raw:** *The cluster's name*
* **ovirt.engine_fqdn.raw:** *The Manager's FQDN*
* **hostname:** *The host's FQDN*
* **ipaddr4:** *IP address*
* **interval:** 10
* **collectd.dstypes:** [Derive](../Derive)

