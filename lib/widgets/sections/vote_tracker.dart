import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:flutter/material.dart';

enum VoteBox { approved, pending, declined }

const Color approvedColor = Color(0xFF66BB6A);
const Color declinedColor = Color.fromARGB(255, 197, 21, 18);

/// One box per member who may vote. The boxes before the approval threshold are
/// outlined, so the border alone says how many approvals still carry the request.
class VoteTracker extends StatelessWidget {
  final int approvals;
  final int rejections;
  final int memberCount;

  /// null when only the creator decides, so no box is part of a threshold.
  final int? requiredApprovals;

  const VoteTracker({
    required this.approvals,
    required this.rejections,
    required this.memberCount,
    required this.requiredApprovals,
    super.key,
  });

  /// Declines sort last so they can never sit inside the outlined region: the
  /// backend rejects the request once they put the threshold out of reach.
  List<VoteBox> get boxes {
    final approved = approvals.clamp(0, memberCount);
    final declined = rejections.clamp(0, memberCount - approved);
    final pending = memberCount - approved - declined;
    return [
      ...List.filled(approved, VoteBox.approved),
      ...List.filled(pending, VoteBox.pending),
      ...List.filled(declined, VoteBox.declined),
    ];
  }

  Color _fill(VoteBox box) {
    switch (box) {
      case VoteBox.approved:
        return approvedColor;
      case VoteBox.declined:
        return declinedColor;
      case VoteBox.pending:
        return AppColors.onPrimaryContainer.withValues(alpha: 0.45);
    }
  }

  static const double boxSize = 20;
  static const double boxGap = 4;
  static const int boxesPerRow = 3;

  static double heightFor(int memberCount) {
    final rows = (memberCount / boxesPerRow).ceil().clamp(1, memberCount);
    return rows * boxSize + (rows - 1) * boxGap;
  }

  @override
  Widget build(BuildContext context) {
    final all = boxes;
    final threshold = requiredApprovals ?? 0;

    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        // a fixed width keeps the wrap deterministic, so heightFor stays exact
        width: boxesPerRow * boxSize + (boxesPerRow - 1) * boxGap,
        child: Wrap(
          spacing: boxGap,
          runSpacing: boxGap,
          children: List.generate(all.length, (index) {
            final counts = index < threshold;
            return Container(
              width: boxSize,
              height: boxSize,
              decoration: BoxDecoration(
                color: _fill(all[index]),
                borderRadius: BorderRadius.circular(4),
                border: counts
                    ? Border.all(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                        width: 1.5,
                      )
                    : null,
              ),
            );
          }),
        ),
      ),
    );
  }
}
