// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:logger/logger.dart' as _i3;

import '../../pages/map/map_store.dart' as _i4;
import '../log/log_it.dart' as _i5;
import 'logger_di.dart' as _i6; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final loggerDi = _$LoggerDi();
  gh.lazySingleton<_i3.Logger>(() => loggerDi.getLogger());
  gh.singleton<_i4.MapStore>(_i4.MapStore());
  gh.lazySingleton<_i5.LogIt>(() => _i5.LogIt(get<_i3.Logger>()));
  return get;
}

class _$LoggerDi extends _i6.LoggerDi {}
