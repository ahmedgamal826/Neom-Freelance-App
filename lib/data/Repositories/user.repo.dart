import '../../core/Providers/FB Firestore/fbfirestore_repo.dart';
import '../Models/App User/app_user.model.dart';

class AppUserRepo extends FirestoreRepo<AppUser> {
  AppUserRepo()
      : super(
          'Users',
        );

  @override
  AppUser? toModel(Map<String, dynamic>? item) => AppUser.fromMap(item ?? {});

  @override
  Map<String, dynamic>? fromModel(AppUser? item) => item?.toMap() ?? {};
}
