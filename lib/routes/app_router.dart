/// Backward-compatibility shim.
///
/// The routing system has moved to `core/routes/`.
/// Import from there directly for new code:
///
///   import 'package:nari_suraksha/core/routes/app_router.dart';
///   import 'package:nari_suraksha/core/routes/app_routes.dart';
///
/// This file re-exports both so that any existing import of
/// `routes/app_router.dart` continues to compile without modification.
library;

export 'package:nari_suraksha/core/routes/app_router.dart';
export 'package:nari_suraksha/core/routes/app_routes.dart';
