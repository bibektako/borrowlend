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
import 'package:borrowlend/features/auth/presentation/view_model/session/session_cubit.dart';
import 'package:borrowlend/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';
import 'package:borrowlend/features/borrow/data/datasource/borrow_remote_data_source.dart';
import 'package:borrowlend/features/borrow/data/datasource/remort_datasource/borrowed_items_remote_datasource.dart';
import 'package:borrowlend/features/borrow/data/repository/remote_repository/borrowed_items_remote_repository.dart';
import 'package:borrowlend/features/borrow/domain/repository/borrowed_item_repository.dart';
import 'package:borrowlend/features/borrow/domain/usecase/create_borrow_request.dart';
import 'package:borrowlend/features/borrow/domain/usecase/get_borrow_request.dart';
import 'package:borrowlend/features/borrow/domain/usecase/update_borrow_request.dart';
import 'package:borrowlend/features/borrow/presentation/view_model/borrow_items_view_model.dart';
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
import 'package:borrowlend/features/review/data/datasource/remote_datasource/review_remote_datasource.dart';
import 'package:borrowlend/features/review/data/datasource/review_datasource.dart';
import 'package:borrowlend/features/review/data/repository/remote_repository/remote_review_repository.dart';
import 'package:borrowlend/features/review/domain/repository/review_repository.dart';
import 'package:borrowlend/features/review/domain/usecase/create_review_usecase.dart';
import 'package:borrowlend/features/review/domain/usecase/delete_review_usecae.dart';
import 'package:borrowlend/features/review/domain/usecase/get_review_usecase.dart';
import 'package:borrowlend/features/review/domain/usecase/update_review_usecase.dart';
import 'package:borrowlend/features/review/presentation/view_model/review_view_model.dart';
import 'package:borrowlend/features/search/presentation/view_model/search_view_model.dart';
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
    serviceLocator.registerLazySingleton<SessionCubit>(() => SessionCubit());
    await _initAuthModule();
    await _initSpashModule();
    await _initOnbordingModule();
    await _initCategoryModule();
    await _initItemModule();
    await _initProfileModule();
    await _initReviewModule();
    await _initBorrowModule();
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
        apiService: serviceLocator<ApiService>(),
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
    serviceLocator.registerLazySingleton<LoginViewModel>(
      () =>
          LoginViewModel(serviceLocator<LoginUserUsecase>(), serviceLocator()),
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

  if (!serviceLocator.isRegistered<SearchViewModel>()) {
    // FIX #2: Correctly use named parameters for the constructor
    serviceLocator.registerFactory<SearchViewModel>(
      () => SearchViewModel(
        getAllItemsUsecase: serviceLocator<GetAllItemsUsecase>(),
        itemViewModel: serviceLocator<ItemViewModel>(),
      ),
    );
  }

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

Future<void> _initReviewModule() async {
  // Data Layer
  // Register ReviewRemoteDataSource as the implementation for IReviewDataSource
  if (!serviceLocator.isRegistered<IReviewDataSource>()) {
    serviceLocator.registerFactory<IReviewDataSource>(
      () => ReviewRemoteDataSource(apiService: serviceLocator<ApiService>()),
    );
  }

  // Register RemoteReviewRepository as the implementation for IReviewRepository
  if (!serviceLocator.isRegistered<IReviewRepository>()) {
    serviceLocator.registerFactory<IReviewRepository>(
      () => RemoteReviewRepository(
        dataSource: serviceLocator<IReviewDataSource>(),
      ),
    );
  }

  // Domain Layer (Use Cases)
  if (!serviceLocator.isRegistered<GetReviewsUsecase>()) {
    serviceLocator.registerFactory<GetReviewsUsecase>(
      () => GetReviewsUsecase(repository: serviceLocator<IReviewRepository>()),
    );
  }
  if (!serviceLocator.isRegistered<CreateReviewUsecase>()) {
    serviceLocator.registerFactory<CreateReviewUsecase>(
      () =>
          CreateReviewUsecase(repository: serviceLocator<IReviewRepository>()),
    );
  }
  if (!serviceLocator.isRegistered<UpdateReviewUsecase>()) {
    serviceLocator.registerFactory<UpdateReviewUsecase>(
      () =>
          UpdateReviewUsecase(repository: serviceLocator<IReviewRepository>()),
    );
  }
  if (!serviceLocator.isRegistered<DeleteReviewUsecase>()) {
    serviceLocator.registerFactory<DeleteReviewUsecase>(
      () =>
          DeleteReviewUsecase(repository: serviceLocator<IReviewRepository>()),
    );
  }

  if (!serviceLocator.isRegistered<ReviewViewModel>()) {
    serviceLocator.registerFactory<ReviewViewModel>(
      () => ReviewViewModel(
        getReviewsUsecase: serviceLocator<GetReviewsUsecase>(),
        createReviewUsecase: serviceLocator<CreateReviewUsecase>(),
        updateReviewUsecase: serviceLocator<UpdateReviewUsecase>(),
        deleteReviewUsecase: serviceLocator<DeleteReviewUsecase>(),
        sessionCubit: serviceLocator<SessionCubit>(),
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
      sessionCubit: serviceLocator(),
      // updateProfileUseCase: serviceLocator<UpdateProfileUseCase>(),
      // logoutUseCase: serviceLocator<LogoutUseCase>(), // Dependency for logout logic
    ),
  );
}

Future<void> _initBorrowModule() async {
  // Data Source
  serviceLocator.registerLazySingleton<IBorrowRemoteDataSource>(
    () => BorrowedItemsRemoteDataSource(serviceLocator<ApiService>()),
  );

  // Repository
  serviceLocator.registerFactory<BorrowedItemsRepository>(
    () => BorrowedItemsRemoteRepository(
      serviceLocator<IBorrowRemoteDataSource>(),
    ),
  );

  // Use Cases
  serviceLocator.registerFactory(
    () => CreateBorrowRequestUseCase(serviceLocator<BorrowedItemsRepository>()),
  );
  serviceLocator.registerFactory(
    () => GetBorrowRequestsUseCase(serviceLocator<BorrowedItemsRepository>()),
  );
  serviceLocator.registerFactory(
    () => UpdateBorrowRequestStatusUseCase(
      serviceLocator<BorrowedItemsRepository>(),
    ),
  );

  // ViewModel (Bloc)
  serviceLocator.registerFactory<BorrowedItemsBloc>(
    () => BorrowedItemsBloc(
      getRequests: serviceLocator<GetBorrowRequestsUseCase>(),
      updateStatus: serviceLocator<UpdateBorrowRequestStatusUseCase>(),
      createRequest: serviceLocator<CreateBorrowRequestUseCase>(),
    ),
  );
}
