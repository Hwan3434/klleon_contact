import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupDi() {
  // DB
  getIt.registerLazySingleton<KDriftDatabase>(() => KDriftDatabase());

  // DAO
  getIt.registerLazySingleton(() => getIt<KDriftDatabase>().contactDao);

  // Datasource
  getIt.registerLazySingleton<ContactLocalDatasource>(
    () => ContactLocalDatasourceImpl(getIt()),
  );

  // Repository
  getIt.registerLazySingleton<ContactRepository>(
    () => ContactRepositoryImpl(getIt()),
  );

  // usecase
  getIt.registerLazySingleton(() => GetContactsUseCase(getIt()));
  getIt.registerLazySingleton(() => CreateContactUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateContactUseCase(getIt()));
  getIt.registerLazySingleton(() => DeleteContactUseCase(getIt()));
}
