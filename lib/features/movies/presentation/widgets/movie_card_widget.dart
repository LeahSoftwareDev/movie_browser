import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/movie_model.dart';
import '../../../favorites/bloc/favorites_bloc.dart';
import '../../../favorites/bloc/favorites_event.dart';
import '../../../favorites/bloc/favorites_state.dart';

class MovieCardWidget extends StatelessWidget {
  final MovieModel movie;
  final VoidCallback onTap;

  const MovieCardWidget({
    super.key,
    required this.movie,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Semantics(
      button: true,
      label: l10n.movieCardLabel(movie.title, movie.year, movie.type),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Semantics(
          button: true,
          label: l10n.movieCardLabel(movie.title, movie.year, movie.type),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  _buildPoster(),
                  const SizedBox(width: 12),
                  _buildInfo(context),
                  _buildFavoriteButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteButton(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        final isFavorite = state is FavoritesLoaded
            ? state.favorites.any((m) => m.imdbId == movie.imdbId)
            : false;

        return Semantics(
          label: isFavorite
              ? l10n.removeMovieFromFavorites(movie.title)
              : l10n.addToFavoritesLabel,
          button: true,
          child: IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.grey,
            ),
            onPressed: () {
              if (isFavorite) {
                context
                    .read<FavoritesBloc>()
                    .add(RemoveFavoriteEvent(movie.imdbId));
              } else {
                context
                    .read<FavoritesBloc>()
                    .add(AddFavoriteEvent(movie));
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildPoster() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: movie.poster != 'N/A'
          ? CachedNetworkImage(
        imageUrl: movie.poster,
        width: 80,
        height: 120,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildPlaceholder(),
        errorWidget: (context, url, error) => _buildPlaceholder(),
      )
          : _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 80,
      height: 120,
      color: Colors.grey[800],
      child: const Icon(Icons.movie, color: Colors.white54),
    );
  }

  Widget _buildInfo(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Expanded(
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
              const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                movie.year,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.movie_filter, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                movie.type.toUpperCase(),
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
           Row(
            children: [
              Icon(Icons.arrow_forward, size: 14, color: Colors.grey),
              SizedBox(width: 4),
              Text(
                l10n.viewDetails,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}