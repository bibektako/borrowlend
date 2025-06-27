import 'package:borrowlend/core/network/hive_service.dart';
import 'package:borrowlend/core/network/api_service.dart';
import 'package:borrowlend/features/auth/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:borrowlend/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:borrowlend/features/auth/data/repository/local_repository/user_local_repository.dart';
import 'package:borrowlend/features/auth/data/repository/remote_repository/user_remote_repository.dart';
import 'package:borrowlend/features/auth/domain/use_case/create_user_usecase.dart';
import 'package:borrowlend/features/auth/domain/use_case/login_user_usecase.dart';
import 'package:borrowlend/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:borrowlend/features/auth/presentation/view_model/onbording_view_model/onbording_view_model.dart';
import 'package:borrowlend/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';
import 'package:borrowlend/features/splash/presentation/view_model/splashscreen_view_model.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;
Future initDependencies() async {
  await _initApiService();
  await _initHiveService();
  await _initAuthModule();
  await _initSpashModule();
  await _initOnbordingModule();
}

Future<void> _initApiService() async {
  serviceLocator.registerLazySingleton(() => ApiService(Dio()));
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

// AUth module
Future _initAuthModule() async {

// data source
  serviceLocator.registerFactory(
    () => UserLocalDatasource(hiveService: serviceLocator<HiveService>()),
  );

  serviceLocator.registerFactory(
    ()=> UserRemoteDatasource(apiService: serviceLocator<ApiService>()),
  );
// Repository
  serviceLocator.registerFactory(
    () => UserLocalRepository(
      userLocalDatasource: serviceLocator<UserLocalDatasource>(),
    ),
  );

  serviceLocator.registerFactory(
    ()=> UserRemoteRepository(userRemoteDatasource: serviceLocator<UserRemoteDatasource>(),),
  );

 

  //usecase
  // serviceLocator.registerFactory(
  //   () => CreateUserUsecase(
  //     userRepository: serviceLocator<UserLocalRepository>(),
  //   ),
  // );

  serviceLocator.registerFactory(
    ()=> CreateUserUsecase(userRepository: serviceLocator<UserRemoteRepository>())
  );

  serviceLocator.registerFactory(
    () =>
        LoginUserUsecase(userRepository: serviceLocator<UserLocalRepository>()),
  );

  
  // view Model
  serviceLocator.registerFactory<SignupViewModel>(
    () =>
        SignupViewModel(createUserUsecase: serviceLocator<CreateUserUsecase>()),
  );

  

  serviceLocator.registerFactory<LoginViewModel>(
    () => LoginViewModel(serviceLocator<LoginUserUsecase>()),
  );
}
