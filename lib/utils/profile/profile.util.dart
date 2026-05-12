// import '../../../models/business.dart';
// import '../../../models/users.dart';
// import '../../../models/wallet.dart';
// import '../locator.dart';
// import '../storage/storage_service.dart';

// class ProfileUtils {
//   UserModel? _loggedUser;
//   Business? _businessOwner;
//   Wallet? _wallet;

//   UserModel? get loggedUser => _loggedUser;
//   Wallet? get wallet => _wallet ?? _loggedUser?.wallet;
//   Business? get loggedBizOwner => _businessOwner;

//   set wallet(Wallet? value) {
//     _wallet = value;
//   }

//   set loggedUser(UserModel? value) {
//     _loggedUser = value;
//   }

//   set loggedUserWallet(Wallet? value) {
//     _loggedUser?.wallet = value;
//     _wallet = value;
//   }

//   set loggedBizOwner(Business? value) {
//     _businessOwner = value;
//   }

//   double? latitude;
//   double? longitude;

//   void reset() {
//     _loggedUser == null;
//     _businessOwner == null;
//   }
// }

// class CurrentProfile {
//   static UserModel? get user => locator<ProfileService>().loggedUser;
//   static int get businessId =>
//       locator<StorageServices>().businessId ??
//       user?.staff.firstOrNull?.businessId ??
//       0;
//   static int get userId => locator<StorageServices>().userId ?? 0;
//   static String get walletId => locator<ProfileService>().wallet!.id;
//   static String get walletUsername =>
//       locator<ProfileService>().wallet!.username;
//   static bool get hasWallet =>
//       locator<ProfileService>().wallet != null ? true : false;
// }
