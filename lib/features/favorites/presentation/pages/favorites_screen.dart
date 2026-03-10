import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../main.dart';
import '../../../favorites/bloc/favorites_bloc.dart';
import '../../../favorites/bloc/favorites_event.dart';
import '../../../favorites/bloc/favorites_state.dart';
import '../../../movies/data/models/movie_model.dart';
import '../../../details/presentation/pages/details_screen.dart';
import '../../../details/bloc/details_bloc.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FavoritesBloc>().add(LoadFavoritesEvent());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title:  Text(l10n.myFavorites),
      ),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoaded) {
            if (state.favorites.isEmpty) {
              return _buildEmpty();
            }
            return _buildList(context, state.favorites);
          }

          if (state is FavoritesError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildEmpty() {
    final l10n = AppLocalizations.of(context)!;

    return  Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            l10n.noFavoritesYet,
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            l10n.addFavoritesHint,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, List<MovieModel> favorites) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final movie = favorites[index];
        return _buildFavoriteCard(context, movie);
      },
    );
  }

  Widget _buildFavoriteCard(BuildContext context, MovieModel movie) {
    final l10n = AppLocalizations.of(context)!;

    return Semantics(
        button: true,
        label: l10n.movieCardLabel(movie.title, movie.year, movie.type),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
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
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _buildPoster(movie.poster),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            movie.year,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Semantics(
                  button: true,
                  label: l10n.removeFromFavoritesLabel,
                  child: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () => context
                        .read<FavoritesBloc>()
                        .add(RemoveFavoriteEvent(movie.imdbId)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPoster(String poster) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: poster != 'N/A'
          ? CachedNetworkImage(
        imageUrl: poster,
        width: 60,
        height: 90,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildPlaceholder(),
        errorWidget: (context, url, error) => _buildPlaceholder(),
      )
          : _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 60,
      height: 90,
      color: Colors.grey[800],
      child: const Icon(Icons.movie, color: Colors.white54),
    );
  }
}