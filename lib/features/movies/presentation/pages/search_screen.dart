import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../l10n/app_localizations.dart';
import '../../bloc/search_bloc.dart';
import '../../bloc/search_event.dart';
import '../../bloc/search_state.dart';
import '../widgets/search_bar_widget.dart';
import 'results_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<SearchBloc>().add(LoadSearchHistoryEvent());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  void _onSearch(String query) {
    if (query.trim().isEmpty) return;
    context.read<SearchBloc>().add(SearchMoviesEvent(query));
  }

  void _onHistoryTap(String query) {
    _controller.text = query;
    _onSearch(query);
  }

  String _getErrorMessage(SearchError state, AppLocalizations l10n) {
    if (state.message.contains('internet')) return l10n.noInternetNoCacheError;
    if (state.message.contains('timed out')) return l10n.timeoutError;
    if (state.message.contains('API key')) return l10n.invalidApiKeyError;
    if (state.message.contains('search term')) return l10n.emptySearchError;
    return l10n.generalError;
  }

  @override
  Widget build(BuildContext context) {

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title:  Text(l10n.appTitle),
        actions: [
          Semantics(
            button: true,
            label: l10n.goToFavoritesLabel,
            child: IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () => Navigator.pushNamed(context, '/favorites'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchBarWidget(
              controller: _controller,
              onSearch: _onSearch,
            ),
          ),
          Expanded(
            child: BlocConsumer<SearchBloc, SearchState>(
              listener: (context, state) {
                if (state is SearchSuccess && state.currentPage == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<SearchBloc>(),
                        child: ResultsScreen(
                          movies: state.movies,
                          query: state.query,
                          isOffline: state.isOffline,
                        ),
                      ),
                    ),
                  ).then((_) {
                    if (mounted) {
                      context.read<SearchBloc>().add(LoadSearchHistoryEvent());
                    }
                  });
                }
              },
              builder: (context, state) {
                if (state is SearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is SearchError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          state.message.contains('internet')
                              ? Icons.wifi_off
                              : state.message.contains('timed out')
                              ? Icons.timer_off
                              : Icons.error_outline,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _getErrorMessage(state, l10n),
                          style: const TextStyle(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => context
                              .read<SearchBloc>()
                              .add(LoadSearchHistoryEvent()),
                          icon: const Icon(Icons.refresh),
                          label:  Text(l10n.goBack),
                        ),
                      ],
                    ),
                  );
                }

                if (state is SearchEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          l10n.noResultsFound(state.query),
                          style: const TextStyle(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                         Text(
                          l10n.tryDifferentTerm,
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  );
                }

                if (state is SearchInitial) {
                  return _buildHistory(state.history);
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistory(List<String> history) {
    final l10n = AppLocalizations.of(context)!;

    if (history.isEmpty) {
      return  Center(
        child: Text(l10n.searchPrompt),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text(
                l10n.recentSearches,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              TextButton(
                onPressed: () =>
                    context.read<SearchBloc>().add(ClearSearchHistoryEvent()),
                child:  Text(l10n.clearAll),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final query = history[index];
              return Dismissible(
                key: Key(query),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) => _deleteHistoryItem(query),
                child: ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(query),
                  onTap: () => _onHistoryTap(query),
                  trailing: IconButton(
                    icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                    onPressed: () => _deleteHistoryItem(query),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _deleteHistoryItem(String query) {
    context.read<SearchBloc>().add(DeleteHistoryItemEvent(query));
  }
}