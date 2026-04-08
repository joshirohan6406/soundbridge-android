import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../models/session.dart';
import '../../../services/join/deep_link_service.dart';

class LinkPasteView extends StatefulWidget {
  final void Function(Session session) onSessionFound;

  const LinkPasteView({super.key, required this.onSessionFound});

  @override
  State<LinkPasteView> createState() => _LinkPasteViewState();
}

class _LinkPasteViewState extends State<LinkPasteView> {
  final _ctrl = TextEditingController();
  String? _error;

  void _tryJoin() {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    final session = DeepLinkService.parseLink(text);
    if (session != null) {
      widget.onSessionFound(session);
    } else {
      setState(() => _error =
          'Invalid link. Make sure you copied the full soundbridge:// link.');
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Paste invite link',
            style: TextStyle(
              fontFamily: SBFonts.dmSans,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: SBColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: SBColors.surface2,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _error != null ? SBColors.red : SBColors.border2,
              ),
            ),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 14),
                  child: Icon(
                    Icons.link_rounded,
                    color: SBColors.textTertiary,
                    size: 18,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    style: TextStyle(
                      fontFamily: SBFonts.dmSans,
                      fontSize: 14,
                      color: SBColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'soundbridge://join?...',
                      hintStyle: TextStyle(
                        color: SBColors.textTertiary,
                        fontFamily: SBFonts.dmSans,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                    onChanged: (_) => setState(() => _error = null),
                    onSubmitted: (_) => _tryJoin(),
                  ),
                ),
              ],
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(
              _error!,
              style: TextStyle(
                fontFamily: SBFonts.dmSans,
                fontSize: 12,
                color: SBColors.red,
              ),
            ),
          ],
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: SBColors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: _tryJoin,
              child: Text(
                'Join session',
                style: TextStyle(
                  fontFamily: SBFonts.dmSans,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
