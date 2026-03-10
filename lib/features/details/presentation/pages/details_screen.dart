import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../details/bloc/details_bloc.dart';
import '../../../details/bloc/details_event.dart';
import '../../../details/bloc/details_state.dart';
import '../../../favorites/bloc/favorites_bloc.dart';
import '../../../favorites/bloc/favorites_event.dart';
import '../../../favorites/bloc/favorites_state.dart';
import '../../../movies/data/models/movie_model.dart';
import '../../data/models/movie_details_model.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetailsScreen extends StatefulWidget {
  final String imdbId;

  const DetailsScreen({super.key, required this.imdbId});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {

  @override
  void initState() {
    super.initState();
    context.read<DetailsBloc>().add(LoadMovieDetailsEvent(widget.imdbId));
    context.read<FavoritesBloc>().add(CheckFavoriteEvent(widget.imdbId));
  }

  String _getErrorMessage(DetailsError state, AppLocalizations l10n) {
    if (state.message.contains('internet')) return l10n.noInternetNoCacheError;
    if (state.message.contains('timed out')) return l10n.timeoutError;
    return l10n.generalError;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: BlocBuilder<DetailsBloc, DetailsState>(
        builder: (context, state) {
          if (state is DetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DetailsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text( _getErrorMessage(state, l10n)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context
                        .read<DetailsBloc>()
                        .add(LoadMovieDetailsEvent(widget.imdbId)),
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            );
          }

          if (state is DetailsSuccess) {
            return _buildContent(context, state.movie, state.isFromCache);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, MovieDetailsModel movie, bool isFromCache) {
    final l10n = AppLocalizations.of(context)!;

    return CustomScrollView(
      slivers: [
        _buildAppBar(context, movie),
        if (isFromCache) // ← חדש
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              color: Colors.orange,
              padding: const EdgeInsets.all(8),
              child:  Row(
                children: [
                  Icon(Icons.wifi_off, size: 16),
                  SizedBox(width: 8),
                  Text(l10n.offlineDetailsBanner),
                ],
              ),
            ),
          ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRating(movie),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.access_time, movie.runtime),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.movie_filter, movie.genre),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.language, movie.language),
                const SizedBox(height: 16),
                _buildSection(l10n.director, movie.director),
                const SizedBox(height: 12),
                _buildSection(l10n.actors, movie.actors),
                const SizedBox(height: 12),
                _buildSection(l10n.plot, movie.plot),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context, MovieDetailsModel movie) {
    final l10n = AppLocalizations.of(context)!;

    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          movie.title,
          style: const TextStyle(fontSize: 14),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        background: movie.poster != 'N/A'
            ? CachedNetworkImage(
          imageUrl: movie.poster,
          fit: BoxFit.cover,
          placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) =>
          const Icon(Icons.movie, size: 80),
        )
            : const Icon(Icons.movie, size: 80),
      ),
      actions: [
        BlocBuilder<FavoritesBloc, FavoritesState>(
          builder: (context, state) {
            final isFavorite =
            state is FavoritesLoaded ? state.isFavorite : false;
            return Semantics(
              button: true,
              label: isFavorite
                  ? l10n.removeMovieFromFavorites(movie.title)
                  : l10n.addToFavoritesLabel,
              child: IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  final movieModel = MovieModel(
                    imdbId: movie.imdbId,
                    title: movie.title,
                    year: movie.year,
                    type: movie.type,
                    poster: movie.poster,
                  );
                  if (isFavorite) {
                    context
                        .read<FavoritesBloc>()
                        .add(RemoveFavoriteEvent(movie.imdbId));
                  } else {
                    context
                        .read<FavoritesBloc>()
                        .add(AddFavoriteEvent(movieModel));
                  }
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRating(MovieDetailsModel movie) {
    return Row(
      children: [
        const Icon(Icons.star, color: Colors.amber, size: 28),
        const SizedBox(width: 8),
        Text(
          movie.imdbRating,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          '/10',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(width: 8),
        Text(
          'IMDb',
          style: TextStyle(color: Colors.grey[400]),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: const TextStyle(height: 1.5),
        ),
      ],
    );
  }
}