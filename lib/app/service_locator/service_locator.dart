import 'package:borrowlend/core/network/hive_service.dart';
import 'package:borrowlend/features/auth/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:borrowlend/features/auth/data/repository/local_repository/user_local_repository.dart';
import 'package:borrowlend/features/auth/domain/use_case/create_user_usecase.dart';
import 'package:borrowlend/features/auth/presentation/view_model/onbording_view_model/onbording_view_model.dart';
import 'package:borrowlend/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';
import 'package:borrowlend/features/splash/presentation/view_model/splashscreen_view_model.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;
Future initDependencies() async {
  await _initHiveService();
  await _initAuthModule();
  await _initSpashModule();
  await _initOnbordingModule();
}

Future _initHiveService() async {
  serviceLocator.registerLazySingleton<HiveService>(() => HiveService());
}

Future _initSpashModule() async {
  serviceLocator.registerFactory(() => SplashscreenViewModel());
}
Future _initOnbordingModule() async {
  serviceLocator.registerFactory(() => OnbordingViewModel());
}

Future _initAuthModule() async {
  serviceLocator.registerFactory(
    () => UserLocalDatasource(hiveService: serviceLocator<HiveService>()),
  );
  serviceLocator.registerFactory(
    () => UserLocalRepository(
      userLocalDatasource: serviceLocator<UserLocalDatasource>(),
    ),
  );
  serviceLocator.registerFactory(
    () => CreateUserUsecase(
      userRepository: serviceLocator<UserLocalRepository>(),
    ),
  );

  serviceLocator.registerFactory<SignupViewModel>(
    () =>
        SignupViewModel(createUserUsecase: serviceLocator<CreateUserUsecase>()),
  );
}
