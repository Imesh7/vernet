import 'dart:io';

import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/material.dart';
import 'package:network_tools/network_tools.dart';

/// Contains all the information of a device in the network including
/// icon, open ports and in the future host name and mDNS name
class DeviceInTheNetwork {
  /// Create basic device with default (not the correct) icon
  DeviceInTheNetwork({
    required this.ip,
    required this.make,
    required this.pingData,
    this.iconData = Icons.devices,
    this.hostId,
  });

  /// Create the object from active host with the correct field and icon
  factory DeviceInTheNetwork.createFromActiveHost({
    required ActiveHost activeHost,
    required String currentDeviceIp,
    required String gatewayIp,
  }) {
    return DeviceInTheNetwork.createWithAllNecessaryFields(
      ip: activeHost.address,
      hostId: activeHost.hostId,
      make: activeHost.deviceName,
      pingData: activeHost.pingData,
      currentDeviceIp: currentDeviceIp,
      gatewayIp: gatewayIp,
    );
  }

  /// Create the object with the correct field and icon
  factory DeviceInTheNetwork.createWithAllNecessaryFields({
    required String ip,
    required String hostId,
    required Future<String> make,
    required PingData pingData,
    required String currentDeviceIp,
    required String gatewayIp,
  }) {
    final IconData iconData = getHostIcon(
      currentDeviceIp: currentDeviceIp,
      hostIp: ip,
      gatewayIp: gatewayIp,
    );

    final Future<String> deviceMake = getDeviceMake(
      currentDeviceIp: currentDeviceIp,
      hostIp: ip,
      gatewayIp: gatewayIp,
      hostMake: make,
    );

    return DeviceInTheNetwork(
      ip: ip,
      make: deviceMake,
      pingData: pingData,
      hostId: hostId,
      iconData: iconData,
    );
  }

  /// Ip of the device
  final String ip;
  final Future<String> make;
  final PingData pingData;
  final IconData iconData;
  String? hostId;

  static Future<String> getDeviceMake({
    required String currentDeviceIp,
    required String hostIp,
    required String gatewayIp,
    required Future<String> hostMake,
  }) async {
    if (currentDeviceIp == hostIp) {
      return 'This device';
    } else if (gatewayIp == hostIp) {
      return 'Router/Gateway';
    }
    return hostMake;
  }

  static IconData getHostIcon({
    required String currentDeviceIp,
    required String hostIp,
    required String gatewayIp,
  }) {
    if (hostIp == currentDeviceIp) {
      if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
        return Icons.computer;
      }
      return Icons.smartphone;
    } else if (hostIp == gatewayIp) {
      return Icons.router;
    }
    return Icons.devices;
  }
}
