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
import 'package:borrowlend/features/items/data/data_source/remote_data_source/bookmark_remote_datasource.dart';
import 'package:borrowlend/features/items/data/data_source/remote_data_source/item_remote_datasource.dart';
import 'package:borrowlend/features/items/data/repository/remote_repository/bookmark_remote_repository.dart';
import 'package:borrowlend/features/items/data/repository/remote_repository/item_remote_repository.dart';
import 'package:borrowlend/features/items/domain/repository/bookmark_repository.dart';
import 'package:borrowlend/features/items/domain/repository/item_repository.dart';
import 'package:borrowlend/features/items/domain/use_case/bookmark/add_bookmark_usecase.dart';
import 'package:borrowlend/features/items/domain/use_case/bookmark/get_bookmark_usecase.dart';
import 'package:borrowlend/features/items/domain/use_case/bookmark/remove_bookmark_usecase.dart';
import 'package:borrowlend/features/items/domain/use_case/create_item_usecase.dart';
import 'package:borrowlend/features/items/domain/use_case/delete_item_usecase.dart';
import 'package:borrowlend/features/items/domain/use_case/get_all_items_usecase.dart';
import 'package:borrowlend/features/items/domain/use_case/get_my_items_usecase.dart';
import 'package:borrowlend/features/items/domain/use_case/update_item_usecase.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_view_model.dart';
import 'package:borrowlend/features/profile/data/data_source/remote_data_source/profile_remote_datasource.dart';
import 'package:borrowlend/features/profile/data/repository/profile_repository.dart';
import 'package:borrowlend/features/profile/domain/repository/profile_repository.dart';
import 'package:borrowlend/features/profile/domain/use_case/get_profile_usecase.dart';
import 'package:borrowlend/features/profile/presentation/view_model/profile_view_model.dart';
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
    await _initItemModule();
    await _initProfileModule();
  }
}

Future<void> _initSharedPrefs() async {
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
    serviceLocator.registerFactory(
      () => SplashscreenViewModel(
        tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
      ),
    );
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

  if (!serviceLocator.isRegistered<LoginUserUsecase>()) {
    serviceLocator.registerFactory(
      () => LoginUserUsecase(
        userRepository: serviceLocator<UserRemoteRepository>(),
        tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
      ),
    );
  }
  // if (!serviceLocator.isRegistered<LogoutUseCase>()) {
  //   serviceLocator.registerFactory<LogoutUseCase>(
  //     () => LogoutUseCase(serviceLocator<UserRemoteRepository>()),
  //   );
  // }

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

//items
Future<void> _initItemModule() async {
  // Data Sources
  if (!serviceLocator.isRegistered<ItemRemoteDataSource>()) {
    serviceLocator.registerFactory<ItemRemoteDataSource>(
      () => ItemRemoteDataSource(apiService: serviceLocator<ApiService>()),
    );
  }
  if (!serviceLocator.isRegistered<BookmarkRemoteDataSource>()) {
    serviceLocator.registerFactory<BookmarkRemoteDataSource>(
      () => BookmarkRemoteDataSource(serviceLocator<ApiService>()),
    );
  }

  // Repositories
  if (!serviceLocator.isRegistered<IItemRepository>()) {
    serviceLocator.registerFactory<IItemRepository>(
      () => ItemRemoteRepository(
        itemRemoteDatasource: serviceLocator<ItemRemoteDataSource>(),
      ),
    );
  }
  if (!serviceLocator.isRegistered<IBookmarkRepository>()) {
    serviceLocator.registerFactory<IBookmarkRepository>(
      () =>
          BookmarkRemoteRepository(serviceLocator<BookmarkRemoteDataSource>()),
    );
  }

  // Use Cases
  if (!serviceLocator.isRegistered<GetAllItemsUsecase>()) {
    serviceLocator.registerFactory<GetAllItemsUsecase>(
      () =>
          GetAllItemsUsecase(itemRepository: serviceLocator<IItemRepository>()),
    );
  }
  if (!serviceLocator.isRegistered<CreateItemUsecase>()) {
    serviceLocator.registerFactory<CreateItemUsecase>(
      () =>
          CreateItemUsecase(itemRepository: serviceLocator<IItemRepository>()),
    );
  }
  if (!serviceLocator.isRegistered<UpdateItemUsecase>()) {
    serviceLocator.registerFactory<UpdateItemUsecase>(
      () =>
          UpdateItemUsecase(itemRepository: serviceLocator<IItemRepository>()),
    );
  }
  if (!serviceLocator.isRegistered<DeleteItemUsecase>()) {
    serviceLocator.registerFactory<DeleteItemUsecase>(
      () => DeleteItemUsecase(
        itemRepository: serviceLocator<IItemRepository>(),
        tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
      ),
    );
  }
  if (!serviceLocator.isRegistered<AddBookmarkUseCase>()) {
    serviceLocator.registerFactory<AddBookmarkUseCase>(
      () => AddBookmarkUseCase(serviceLocator<IBookmarkRepository>()),
    );
  }
  if (!serviceLocator.isRegistered<RemoveBookmarkUseCase>()) {
    serviceLocator.registerFactory<RemoveBookmarkUseCase>(
      () => RemoveBookmarkUseCase(serviceLocator<IBookmarkRepository>()),
    );
  }
  if (!serviceLocator.isRegistered<GetBookmarksUseCase>()) {
    serviceLocator.registerFactory<GetBookmarksUseCase>(
      () => GetBookmarksUseCase(serviceLocator<IBookmarkRepository>()),
    );
  }
  serviceLocator.registerFactory(() => GetMyItemsUseCase(serviceLocator()));

  if (!serviceLocator.isRegistered<ItemViewModel>()) {
    serviceLocator.registerLazySingleton<ItemViewModel>(
      () => ItemViewModel(
        getAllItemsUsecase: serviceLocator<GetAllItemsUsecase>(),
        createItemUsecase: serviceLocator<CreateItemUsecase>(),
        updateItemUsecase: serviceLocator<UpdateItemUsecase>(),
        deleteItemUsecase: serviceLocator<DeleteItemUsecase>(),
        addBookmarkUseCase: serviceLocator<AddBookmarkUseCase>(),
        removeBookmarkUseCase: serviceLocator<RemoveBookmarkUseCase>(),
        getBookmarksUseCase: serviceLocator<GetBookmarksUseCase>(), 
        getMyItemsUsecase: serviceLocator<GetMyItemsUseCase>(),
      ),
    );
  }
}

Future<void> _initProfileModule() async {
  // Data Layer
  serviceLocator.registerFactory<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSource(serviceLocator<ApiService>()),
  );
  serviceLocator.registerFactory<IProfileRepository>(
    () => ProfileRepositoryImpl(serviceLocator<ProfileRemoteDataSource>()),
  );

  // Domain Layer
  serviceLocator.registerFactory<GetProfileUseCase>(
    () => GetProfileUseCase(serviceLocator<IProfileRepository>()),
  );
  // serviceLocator.registerFactory<UpdateProfileUseCase>(
  //   () => UpdateProfileUseCase(serviceLocator<IProfileRepository>()),
  // );

  // Presentation Layer
  serviceLocator.registerFactory<ProfileViewModel>(
    () => ProfileViewModel(
      getProfileUseCase: serviceLocator<GetProfileUseCase>(),
      // updateProfileUseCase: serviceLocator<UpdateProfileUseCase>(),
      // logoutUseCase: serviceLocator<LogoutUseCase>(), // Dependency for logout logic
    ),
  );
}
