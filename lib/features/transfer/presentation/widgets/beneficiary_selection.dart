import 'package:banking_app/app/themes/app_theme.dart';
import 'package:banking_app/core/common/extensions/context_extensions.dart';
import 'package:banking_app/core/resources/l10n_generated/l10n.dart';
import 'package:banking_app/core/widgets/assets.dart';
import 'package:banking_app/core/widgets/snackbar.dart';
import 'package:banking_app/features/transfer/data/models/bank_model.dart';
import 'package:banking_app/features/transfer/data/models/beneficiary_model.dart';
import 'package:banking_app/features/transfer/presentation/blocs/transfer_bloc.dart';
import 'package:banking_app/features/transfer/presentation/blocs/transfer_event.dart';
import 'package:banking_app/features/transfer/presentation/blocs/transfer_state.dart';
import 'package:banking_app/features/transfer/presentation/views/add_new_benificiary_screen.dart';
import 'package:banking_app/features/transfer/presentation/views/directory_beneficiary_screen.dart';
import 'package:banking_app/features/transfer/presentation/widgets/beneficiary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A widget for selecting a beneficiary.
///
/// This widget displays a horizontal list of beneficiaries and allows the user
/// to select one or add a new one. Supports drag-and-drop reordering via long press.
class BeneficiarySelection extends StatelessWidget {
  const BeneficiarySelection({
    super.key,
    required this.state,
    required this.onBeneficiarySelected,
  });

  final TransferState state;
  final Function(BeneficiaryModel) onBeneficiarySelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BeneficiarySelectionHeader(banks: state.banks),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: state.filteredBeneficiaries.isEmpty
              ? Center(
                  child: Text(
                    S.current.transferNoBeneficiariesFoundTitle,
                    style: context.bodyMedium,
                  ),
                )
              : Row(
                  children: [
                    // Add beneficiary card (first item, not reorderable)
                    Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 12),
                      child: _AddBeneficiaryCard(banks: state.banks),
                    ),
                    // Reorderable beneficiaries list (separated for cleaner logic)
                    Expanded(
                      child: ReorderableListView.builder(
                        scrollDirection: Axis.horizontal,
                        buildDefaultDragHandles: false,
                        // Enhanced proxy decorator with elevation and shadow
                        proxyDecorator: _buildDragProxyDecorator,
                        onReorderStart: _handleReorderStart,
                        onReorder: (oldIndex, newIndex) =>
                            _handleReorder(context, oldIndex, newIndex),
                        itemCount: state.filteredBeneficiaries.length,
                        itemBuilder: (context, index) {
                          final beneficiary =
                              state.filteredBeneficiaries[index];
                          final isSelected =
                              state.selectedBeneficiary?.id == beneficiary.id;

                          return ReorderableDelayedDragStartListener(
                            key: ValueKey(beneficiary.id ?? index),
                            index: index,
                            child: _DraggableBeneficiaryCard(
                              beneficiary: beneficiary,
                              isSelected: isSelected,
                              onTap: () {
                                context.read<TransferBloc>().add(
                                  SelectBeneficiaryEvt(beneficiary),
                                );
                                onBeneficiarySelected(beneficiary);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  /// Builds enhanced drag proxy with elevation and shadow for better UX
  Widget _buildDragProxyDecorator(
    Widget child,
    int index,
    Animation<double> animation,
  ) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final animValue = Curves.easeInOut.transform(animation.value);
        final scale = 1.0 + (animValue * 0.15);
        final elevation = animValue * 8.0;

        return Transform.scale(
          scale: scale,
          child: Material(
            elevation: elevation,
            borderRadius: BorderRadius.circular(12),
            shadowColor: context.colorScheme.shadow.withAlpha(0x4D),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  /// Handles reorder start with haptic feedback
  void _handleReorderStart(int index) {
    HapticFeedback.mediumImpact();
  }

  /// Handles reorder with validation and user feedback
  void _handleReorder(BuildContext context, int oldIndex, int newIndex) {
    // Adjust newIndex if moving down (ReorderableListView behavior)
    final adjustedNewIndex = newIndex > oldIndex ? newIndex - 1 : newIndex;

    context.read<TransferBloc>().add(
      ReorderBeneficiaryEvt(oldIndex: oldIndex, newIndex: adjustedNewIndex),
    );

    // Haptic feedback on successful reorder
    HapticFeedback.lightImpact();

    // Show success feedback
    BASnackBar.buildSuccessSnackbar(
      context,
      S.current.transferBeneficiaryOrderUpdated,
    );
  }
}

/// The header of the beneficiary selection widget.
class _BeneficiarySelectionHeader extends StatelessWidget {
  const _BeneficiarySelectionHeader({required this.banks});

  final List<BankModel> banks;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          S.current.transferChooseBeneficiaryTitle,
          style: context.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: context.colorScheme.inverseSurface,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<TransferBloc>(),
                  child: DirectoryBeneficiaryScreen(banks: banks),
                ),
              ),
            );
          },
          child: Text(
            S.current.transferFindBeneficiaryTitle,
            style: context.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: context.colorScheme.secondary,
            ),
          ),
        ),
      ],
    );
  }
}

/// A card for adding a new beneficiary.
class _AddBeneficiaryCard extends StatelessWidget {
  final List<BankModel> banks;

  const _AddBeneficiaryCard({required this.banks});

  @override
  Widget build(BuildContext context) {
    return BeneficiaryCard(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<TransferBloc>(),
              child: AddNewBeneficiaryScreen(
                banks: banks,
                onBeneficiaryAdded: (b) {
                  context.read<TransferBloc>().add(AddNewBeneficiaryEvt(b));
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        );
      },
      child: Center(
        child: CircleAvatar(
          radius: 28,
          backgroundColor: context.colorScheme.outlineVariant,
          child: Icon(Icons.add, color: context.colorScheme.onPrimary),
        ),
      ),
    );
  }
}

/// A widget for displaying a beneficiary's avatar.
class BeneficiaryAvatar extends StatelessWidget {
  final String? avatarUrl;

  const BeneficiaryAvatar({super.key, this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return BAProfileImage(
      url: avatarUrl,
      size: 60,
      backgroundColor: context.colorScheme.outlineVariant,
      iconColor: context.colorScheme.onPrimary,
    );
  }
}

/// Draggable beneficiary card for reorderable list
class _DraggableBeneficiaryCard extends StatelessWidget {
  const _DraggableBeneficiaryCard({
    required this.beneficiary,
    required this.isSelected,
    required this.onTap,
  });

  final BeneficiaryModel beneficiary;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      child: Material(
        type: MaterialType.transparency,
        child: BeneficiaryCard(
          width: 100,
          isSelected: isSelected,
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BeneficiaryAvatar(avatarUrl: beneficiary.avatarUrl),
              const SizedBox(height: 6),
              Text(
                beneficiary.name,
                style: context.bodyMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? context.colorScheme.onSecondary
                      : context.colorScheme.scrim,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
