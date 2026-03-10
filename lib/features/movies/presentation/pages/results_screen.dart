import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../l10n/app_localizations.dart';
import '../../bloc/search_bloc.dart';
import '../../bloc/search_event.dart';
import '../../bloc/search_state.dart';
import '../../data/models/movie_model.dart';
import '../widgets/movie_card_widget.dart';
import '../../../details/presentation/pages/details_screen.dart';
import '../../../favorites/bloc/favorites_bloc.dart';
import '../../../favorites/bloc/favorites_event.dart';
import '../../../details/bloc/details_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../main.dart';

class ResultsScreen extends StatefulWidget {
  final List<MovieModel> movies;
  final String query;
  final bool isOffline;

  const ResultsScreen({
    super.key,
    required this.movies,
    required this.query,
    this.isOffline = false,
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<FavoritesBloc>().add(LoadFavoritesEvent());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<SearchBloc>().add(LoadMoreMoviesEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.resultsFor(widget.query)),
        actions: [
          Semantics(
            label: l10n.goToFavoritesLabel,
            button: true,
            child: IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () => Navigator.pushNamed(context, '/favorites'),
            ),
          ),
        ],
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          List<MovieModel> movies = widget.movies;
          bool isOffline = widget.isOffline;
          bool hasMore = false;
          bool isLoadingMore = false;

          if (state is SearchSuccess) {
            movies = state.movies;
            isOffline = state.isOffline;
            hasMore = state.hasMore;
          }

          if (state is SearchLoadingMore) {
            movies = state.currentMovies;
            isLoadingMore = true;
          }

          return Column(
            children: [
              if (isOffline)
                Container(
                  width: double.infinity,
                  color: Colors.orange,
                  padding: const EdgeInsets.all(8),
                  child:  Row(
                    children: [
                      Icon(Icons.wifi_off, size: 16),
                      SizedBox(width: 8),
                      Text(l10n.offlineBanner),
                    ],
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: movies.length + (isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == movies.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final movie = movies[index];
                    return MovieCardWidget(
                      movie: movie,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create: (_) => getIt<DetailsBloc>(),
                              ),
                              BlocProvider.value(
                                value: context.read<FavoritesBloc>(),
                              ),
                            ],
                            child: DetailsScreen(imdbId: movie.imdbId),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}