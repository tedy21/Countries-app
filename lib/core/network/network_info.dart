abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get connectivityStream;
}

class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl();
  
  @override
  Future<bool> get isConnected async {
    return true;
  }
  
  @override
  Stream<bool> get connectivityStream {
    return Stream.value(true);
  }
}
