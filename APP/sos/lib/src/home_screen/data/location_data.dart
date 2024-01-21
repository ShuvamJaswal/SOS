import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sos/main.dart';
import 'package:sos/src/auth/data/my_profile.dart';
part 'location_data.g.dart';

class LocationData {
  GeoFlutterFire geo = GeoFlutterFire();
  LocationData(this.ref) {}
  final Ref ref;
  List data = [];
  Future setCurrentLocation() async {
    String? token = await FirebaseMessaging.instance.getToken();
    Position Pos = await getCurrentLocation();

    GeoFirePoint geoFirePoint =
        geo.point(latitude: Pos.latitude, longitude: Pos.longitude);
    String user = FirebaseAuth.instance.currentUser!.uid;
    final firestore = ref.watch(firestoreInstanceProvider);

    firestore.collection('users').doc(user).set(
        {'position': geoFirePoint.data, 'message_token': token},
        SetOptions(merge: true));
  }

  Future<Position> getCurrentLocation() async {
    if (await Geolocator.checkPermission() != LocationPermission.always &&
        await Geolocator.checkPermission() != LocationPermission.whileInUse) {
      await Geolocator.requestPermission();
    }
    int timeOut = 0;
    while (ref.watch(liveLocationServiceProvider).hasLocation() == false &&
        timeOut < 20) {
      await Future.delayed(Duration(seconds: 1));
      timeOut += 1;
    }
    Position posi = await ref.watch(liveLocationServiceProvider).s?.value;
    return posi;
  }

  Future<List> getNearbyUsers(double radius, Position Pos) async {
    data = [];
    final firestore = ref.watch(firestoreInstanceProvider);

    CollectionReference collectionReference = firestore.collection('users');

    Stream<List<DocumentSnapshot<Object?>>> st = geo
        .collection(collectionRef: collectionReference)
        .within(
            center: GeoFirePoint(Pos.latitude, Pos.longitude),
            radius: radius,
            field: 'position',
            strictMode: true);
    var p = await st.take(1).toList();
    for (var document in p[0]) {
      if (document.data() != null) {
        Map<String, dynamic> snapData = document.data() as Map<String, dynamic>;
        data.add(snapData['message_token']);
        // print(snapData);
      }
    }
    // return;
    // st.take(1).listen((documentList) {
    //   documentList.forEach((DocumentSnapshot document) {
    //     if (document.data() != null) {
    //       Map<String, dynamic> snapData =
    //           document.data() as Map<String, dynamic>;
    //       data.add(snapData['message_token']);
    //       // print(snapData);
    //     }
    //   });
    // }).onDone(() async {
    //   data = data.toSet().toList();
    //   print(data);
    //   data.remove(await FirebaseMessaging.instance.getToken());
    // });
    data = data.toSet().toList();
    print(data);
    data.remove(await FirebaseMessaging.instance.getToken());
    return data;
    // await st.first.then((documentList) {
    //   documentList.forEach((DocumentSnapshot document) {
    //     if (document.data() != null) {
    //       Map<String, dynamic> snapData =
    //           document.data() as Map<String, dynamic>;
    //       data.add(snapData['message_token']);
    //       // print(snapData);
    //     }
    //   });
    // });
  }
}

@riverpod
LocationData locationData(LocationDataRef ref) {
  return LocationData(ref);
}

// @Riverpod(keepAlive: true)
// FutureOr<Position> LocationDataProvider(Ref ref) {
//   return LocationData().getCurrentLocation();
// }
// @Riverpod(keepAlive: true)
// Stream<Position> appp(ApppRef ref) {
//   return Geolocator.getPositionStream(
//       locationSettings: LocationSettings(distanceFilter: 0));
// }

// @Riverpod(keepAlive: true)
// FutureOr<Position> liveLocation(LiveLocationRef ref) async {
//   if (await Geolocator.checkPermission() != LocationPermission.always) {
//     await Geolocator.requestPermission();
//   }

//   Position pos = await Geolocator.getCurrentPosition(
//     desiredAccuracy: LocationAccuracy.best,
//   );
//   Geolocator.getPositionStream(
//           locationSettings: LocationSettings(distanceFilter: 0))
//       .listen((event) {
//     pos = event;
//     FirebaseFirestore.instance
//         .collection('locations')
//         .add({'name': 'random name', 'livelocation': pos.toString()});
//   });
//   return pos;
// }

// @Riverpod(keepAlive: true)
// class currentLocation extends _$currentLocation {
//   @override
//   Stream<Position> build() {
//     return Geolocator.getPositionStream(
//         locationSettings: LocationSettings(distanceFilter: 0));
//   }
// }
