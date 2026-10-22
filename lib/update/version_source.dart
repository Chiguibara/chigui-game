import 'version_source_stub.dart'
    if (dart.library.js_interop) 'version_source_web.dart'
    as platform;

/// Where the game learns which version is deployed: the web build's own
/// `version.json`, on the same server as the game.
abstract interface class VersionSource {
  /// The deployed version (e.g. `1.0.3+57`), or null if it could not be
  /// read (offline, or any other failure).
  Future<String?> latest();

  /// Loads the deployed version.
  void reload();
}

/// The version source for this platform, or null outside the web (store
/// apps are updated by the store).
VersionSource? createVersionSource() => platform.createVersionSource();
