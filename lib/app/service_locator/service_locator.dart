import 'package:borrowlend/app/shared_pref/token_shared_prefs.dart';
import 'package:borrowlend/core/network/api_service.dart';
import 'package:borrowlend/core/network/hive_service.dart';
import 'package:borrowlend/features/auth/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:borrowlend/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:borrowlend/features/auth/data/repository/local_repository/user_local_repository.dart';
import 'package:borrowlend/features/auth/data/repository/remote_repository/user_remote_repository.dart';
import 'package:borrowlend/features/auth/domain/use_case/create_user_usecase.dart';
import 'package:borrowlend/features/auth/domain/use_case/login_user_usecase.dart';
import 'package:borrowlend/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:borrowlend/features/auth/presentation/view_model/onbording_view_model/onbording_view_model.dart';
import 'package:borrowlend/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';
import 'package:borrowlend/features/category/data/data_source/remote_data_source/category_remote_data_source.dart';
import 'package:borrowlend/features/category/data/repository/remote_repository/category_remote_repository.dart';
import 'package:borrowlend/features/category/domain/use_case/get_all_category_usecase.dart';
import 'package:borrowlend/features/category/presentation/view_model/category_viewmodel.dart';
import 'package:borrowlend/features/splash/presentation/view_model/splashscreen_view_model.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // This check correctly prevents re-initialization
  if (!serviceLocator.isRegistered<HiveService>()) {
    await _initHiveService();
    await _initApiService();
    await _initSharedPrefs();
    await _initAuthModule();
    await _initSpashModule();
    await _initOnbordingModule();
    await _initCategoryModule();
  }
}

Future<void> _initSharedPrefs() async {
  // Initialize Shared Preferences if needed
  final sharedPrefs = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPrefs);
  serviceLocator.registerLazySingleton(
    () => TokenSharedPrefs(
      sharedPreferences: serviceLocator<SharedPreferences>(),
    ),
  );
}

Future<void> _initApiService() async {
  if (!serviceLocator.isRegistered<ApiService>()) {
    serviceLocator.registerLazySingleton(() => ApiService(Dio()));
  }
}

Future<void> _initHiveService() async {
  if (!serviceLocator.isRegistered<HiveService>()) {
    serviceLocator.registerLazySingleton<HiveService>(() => HiveService());
  }
}

Future<void> _initSpashModule() async {
  if (!serviceLocator.isRegistered<SplashscreenViewModel>()) {
    serviceLocator.registerFactory(() => SplashscreenViewModel());
  }
}

Future<void> _initOnbordingModule() async {
  if (!serviceLocator.isRegistered<OnbordingViewModel>()) {
    serviceLocator.registerFactory(() => OnbordingViewModel());
  }
}

// Auth module
Future<void> _initAuthModule() async {
  // Data Sources
  if (!serviceLocator.isRegistered<UserLocalDatasource>()) {
    serviceLocator.registerFactory(
      () => UserLocalDatasource(hiveService: serviceLocator<HiveService>()),
    );
  }
  if (!serviceLocator.isRegistered<UserRemoteDatasource>()) {
    serviceLocator.registerFactory(
      () => UserRemoteDatasource(apiService: serviceLocator<ApiService>()),
    );
  }

  // Repositories
  if (!serviceLocator.isRegistered<UserLocalRepository>()) {
    serviceLocator.registerFactory<UserLocalRepository>(
      () => UserLocalRepository(
        userLocalDatasource: serviceLocator<UserLocalDatasource>(),
      ),
    );
  }
  if (!serviceLocator.isRegistered<UserRemoteRepository>()) {
    serviceLocator.registerFactory<UserRemoteRepository>(
      () => UserRemoteRepository(
        userRemoteDatasource: serviceLocator<UserRemoteDatasource>(),
      ),
    );
  }

  // Use Cases
  if (!serviceLocator.isRegistered<CreateUserUsecase>()) {
    serviceLocator.registerFactory(
      () => CreateUserUsecase(
        userRepository: serviceLocator<UserRemoteRepository>(),
      ),
    );
  }

  // THE FIX: Ensure LoginUserUsecase gets the UserRemoteRepository
  if (!serviceLocator.isRegistered<LoginUserUsecase>()) {
    serviceLocator.registerFactory(
      () => LoginUserUsecase(
        userRepository: serviceLocator<UserRemoteRepository>(),
        tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
      ),
    );
  }

  // View Models
  if (!serviceLocator.isRegistered<SignupViewModel>()) {
    serviceLocator.registerFactory<SignupViewModel>(
      () => SignupViewModel(
        createUserUsecase: serviceLocator<CreateUserUsecase>(),
      ),
    );
  }
  if (!serviceLocator.isRegistered<LoginViewModel>()) {
    serviceLocator.registerFactory<LoginViewModel>(
      () => LoginViewModel(serviceLocator<LoginUserUsecase>()),
    );
  }
}

Future<void> _initHomeModule() async {
  serviceLocator.registerFactory(
    () => CategoryRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );
}

Future<void> _initCategoryModule() async {
  serviceLocator.registerFactory(
    () => CategoryRemoteDataSource(apiService: serviceLocator<ApiService>()),
  );

  serviceLocator.registerFactory(
    () => CategoryRemoteRepository(
      categoryRemoteDataSource: serviceLocator<CategoryRemoteDataSource>(),
    ),
  );

  serviceLocator.registerFactory(
    () => GetAllCategoryUsecase(
      categoryRepository: serviceLocator<CategoryRemoteRepository>(),
    ),
  );
  serviceLocator.registerFactory(
    () => CategoryBloc(
      getAllCategoryUsecase: serviceLocator<GetAllCategoryUsecase>(),
    ),
  );
}
