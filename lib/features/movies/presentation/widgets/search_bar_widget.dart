import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSearch;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: Semantics(
            textField: true,
            label: l10n.searchHint,
            child: TextField(
              controller: controller,
              onSubmitted: onSearch,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: l10n.searchHint,
                  suffixIcon: Semantics(
                    label: l10n.clearSearchLabel,
                    button: true,
                    child: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => controller.clear(),
                    ),
                  ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Semantics(
          label: l10n.searchButton,
          button: true,
          child: ElevatedButton(
            onPressed: () => onSearch(controller.text),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Icon(Icons.search),
          ),
        ),
      ],
    );
  }
}