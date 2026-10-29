import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/network/clearance/clearance.dart';
import '../../../../core/network/clearance/clearance_store.dart';
import '../../../../shared/widgets/text_input_dialog.dart';

/// Settings → Extensions → Address redirects.
///
/// When a site an extension uses moves to a new domain, the person adds
/// "old address → new address" here. Every request to the old host, from
/// SkyStream extensions and CloudStream (.cs3) extensions alike, then goes to
/// the new one with its path and query kept. Redirects set here stay until
/// removed; the ones the app learned by itself from permanent redirects are
/// listed too, and can be removed.
void showAddressRedirectsDialog(BuildContext context) {
  final clearance = Clearance.instance;
  if (!clearance.isReady) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ağ katmanı henüz hazır değil, birazdan tekrar deneyin.')),
    );
    return;
  }
  showDialog<void>(context: context, builder: (_) => _AddressRedirectsDialog(store: clearance.store));
}

class _AddressRedirectsDialog extends StatefulWidget {
  const _AddressRedirectsDialog({required this.store});

  final ClearanceStore store;

  @override
  State<_AddressRedirectsDialog> createState() => _AddressRedirectsDialogState();
}

class _AddressRedirectsDialogState extends State<_AddressRedirectsDialog> {
  late final StreamSubscription<void> _changes;

  @override
  void initState() {
    super.initState();
    _changes = widget.store.changes.listen((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    unawaited(_changes.cancel());
    super.dispose();
  }

  /// "site.com", "https://site.com/x" or "www.site.com" → an http(s) URI with a host.
  static Uri? _parse(String raw) {
    var value = raw.trim();
    if (value.isEmpty) return null;
    if (!RegExp(r'^https?://', caseSensitive: false).hasMatch(value)) value = 'https://$value';
    final uri = Uri.tryParse(value);
    if (uri == null || uri.host.isEmpty || (uri.scheme != 'http' && uri.scheme != 'https')) return null;
    return uri;
  }

  void _say(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _add({String? fromHost, Uri? currentTo}) async {
    final fromText = fromHost ??
        await TextInputDialog.show(
          context,
          title: 'Eski adres',
          message: 'Eklentinin kullandığı, artık çalışmayan adres. Ör. eskisite.com',
          hintText: 'eskisite.com',
          keyboardType: TextInputType.url,
          confirmLabel: 'İleri',
          showPasteButton: true,
        );
    if (fromText == null || !mounted) return;
    final from = _parse(fromText);
    if (from == null) return _say('Geçerli bir eski adres girin.');

    final toText = await TextInputDialog.show(
      context,
      title: 'Yeni adres',
      message: '${from.host} adresine giden istekler buraya gönderilecek.',
      initialText: currentTo?.toString() ?? '',
      hintText: 'https://yenisite.com',
      keyboardType: TextInputType.url,
      confirmLabel: 'Kaydet',
      showPasteButton: true,
    );
    if (toText == null || !mounted) return;
    final to = _parse(toText);
    if (to == null) return _say('Geçerli bir yeni adres girin.');
    if (to.host == from.host) return _say('Yeni adres eskisiyle aynı.');

    widget.store.setManualMove(from.host, to);
    _say('${from.host} → ${to.host} kaydedildi');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final moves = widget.store.moves.entries.toList()..sort((a, b) => a.key.compareTo(b.key));

    return AlertDialog(
      surfaceTintColor: Colors.transparent,
      title: const Text('Adres yönlendirmeleri'),
      content: SizedBox(
        width: 460,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bir sitenin alan adı değiştiğinde eski adresi yenisine yönlendirin. '
              'SkyStream ve CloudStream eklentilerinin tüm istekleri, yol ve parametreler korunarak yeni adrese gider.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            if (moves.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(child: Text('Henüz yönlendirme yok', style: theme.textTheme.bodyMedium)),
              )
            else
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final move in moves)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          widget.store.isManualMove(move.key) ? Icons.push_pin_rounded : Icons.auto_mode_rounded,
                          color: theme.colorScheme.primary,
                        ),
                        title: Text(move.key, maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle: Text(
                          '→ ${move.value.host}${widget.store.isManualMove(move.key) ? '' : '  (otomatik)'}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () => _add(fromHost: move.key, currentTo: move.value),
                        trailing: IconButton(
                          tooltip: 'Kaldır',
                          icon: const Icon(Icons.delete_outline_rounded),
                          onPressed: () => widget.store.removeManualMove(move.key),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(MaterialLocalizations.of(context).closeButtonLabel),
        ),
        FilledButton.icon(
          onPressed: () => _add(),
          icon: const Icon(Icons.add_rounded),
          label: const Text('Yönlendirme ekle'),
        ),
      ],
    );
  }
}
