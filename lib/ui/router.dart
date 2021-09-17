import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms_app/constants/route_names.dart';
import 'package:lms_app/features/me/bloc/me_bloc.dart';
import 'package:lms_app/features/media_devices/bloc/media_devices_bloc.dart';
import 'package:lms_app/features/peers/bloc/peers_bloc.dart';
import 'package:lms_app/features/producers/bloc/producers_bloc.dart';
import 'package:lms_app/features/room/bloc/room_bloc.dart';
import 'package:lms_app/features/signaling/room_client_repository.dart';
import 'package:lms_app/screens/room/room.dart';
import 'package:lms_app/screens/room/room_modules.dart';
import 'package:lms_app/screens/welcome/welcome.dart';
import 'package:lms_app/ui/views/details_view.dart';
import 'package:lms_app/ui/views/home_view.dart';
import 'package:lms_app/ui/views/login_view.dart';
import 'package:random_string/random_string.dart';


Route<dynamic> generateRoute(RouteSettings settings) {
  print("name= ${settings.name}");
  switch (settings.name) {
    case Room.RoutePath:
      {
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
              providers: getRoomModules(settings: settings),
              child: RepositoryProvider(
                lazy: false,
                create: (context) {
                  final meState = context.read<MeBloc>().state;
                  String displayName = meState.displayName;
                  String id = meState.id;
                  final roomState = context.read<RoomBloc>().state;
                  String url = roomState.url;
                  print("RoomURl ${url}");
                  Uri uri = Uri.parse(url);

                  return RoomClientRepository(
                    peerId: id,
                    displayName: displayName,
                    url:
                    'wss://mediasoup.oyuntan.mn:4443',
                    roomId: uri.queryParameters['roomId'] ??
                        uri.queryParameters['roomid'] ??
                        randomAlpha(8).toLowerCase(),
                    peersBloc: context.read<PeersBloc>(),
                    producersBloc: context.read<ProducersBloc>(),
                    meBloc: context.read<MeBloc>(),
                    roomBloc: context.read<RoomBloc>(),
                    mediaDevicesBloc: context.read<MediaDevicesBloc>(),
                  )..join();
                },
                child: Room(),
              )),
        );
      }
    case Welcome.RoutePath:
      {
        return MaterialPageRoute(
          builder: (context) => Welcome(),
        );
      }
    case LoginViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: LoginView(),
      );
    case HomeViewRoute:
    return _getPageRoute(
      routeName: settings.name,
      viewToShow: HomeView(),
    );
    case DetailsViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: DetailsView(),
      );
    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
                child: Text('No route defined for ${settings.name}')),
          ));
  }
}

PageRoute _getPageRoute({String routeName, Widget viewToShow}) {
  return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
      ),
      builder: (_) => viewToShow);
}