import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'core/api/dio_client.dart';
import 'core/storage/hive_service.dart';
import 'features/movies/data/repositories/movie_repository.dart';
import 'features/details/data/repositories/details_repository.dart';
import 'features/favorites/data/repositories/favorites_repository.dart';
import 'features/movies/bloc/search_bloc.dart';
import 'features/details/bloc/details_bloc.dart';
import 'features/favorites/bloc/favorites_bloc.dart';
import 'features/movies/presentation/pages/search_screen.dart';
import 'features/favorites/presentation/pages/favorites_screen.dart';
import 'l10n/app_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final GetIt getIt = GetIt.instance;

void _setupDependencies() {
  getIt.registerSingleton(DioClient.instance);
  getIt.registerSingleton(MovieRepository(getIt()));
  getIt.registerSingleton(DetailsRepository(getIt()));
  getIt.registerSingleton(FavoritesRepository());
  getIt.registerFactory(() => SearchBloc(getIt()));
  getIt.registerFactory(() => DetailsBloc(getIt()));
  getIt.registerFactory(() => FavoritesBloc(getIt()));
}



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await HiveService.init();
  _setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<SearchBloc>()),
        BlocProvider(create: (_) => getIt<FavoritesBloc>()),
      ],
      child: MaterialApp(
        title: 'Movie Browser',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFE50914),
          ),
        ),
        builder: (context, child) {
          final mediaQuery = MediaQuery.of(context);
          return MediaQuery(
            data: mediaQuery.copyWith(
              textScaler: mediaQuery.textScaler.clamp(
                minScaleFactor: 1.0,
                maxScaleFactor: 1.3,
              ),
            ),
            child: child!,
          );
        },
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
        ],
        initialRoute: '/',
        routes: {
          '/': (_) => const SearchScreen(),
          '/favorites': (context) => BlocProvider.value(
            value: getIt<FavoritesBloc>(),
            child: const FavoritesScreen(),
          ),
        },
      ),
    );
  }
}