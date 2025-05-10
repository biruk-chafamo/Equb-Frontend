import 'package:equb_v3_frontend/models/payment_method/payment_method.dart';
import 'package:equb_v3_frontend/models/user/user.dart';
import 'package:equb_v3_frontend/screens/user/user_profile_screen.dart';
import 'package:equb_v3_frontend/utils/constants.dart';
import 'package:equb_v3_frontend/widgets/buttons/bidding_input.dart';
import 'package:equb_v3_frontend/widgets/buttons/custom_elevated_button.dart';
import 'package:equb_v3_frontend/widgets/cards/equb_detail_summary.dart';
import 'package:equb_v3_frontend/widgets/cards/user_detail.dart';
import 'package:equb_v3_frontend/widgets/tiles/section_title_tile.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class EqubOverviewPlaceholder extends StatelessWidget {
  final EqubType equbType;
  const EqubOverviewPlaceholder({
    required this.equbType,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Shimmer.fromColors(
        period: const Duration(milliseconds: 2500),
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade200,
        child: Column(
          children: [
            Padding(
              padding: AppPadding.globalPadding,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Row(
                      children: [
                        const Icon(Icons.circle,
                            color: Colors.white, size: smallIconSize),
                        const SizedBox(width: 5),
                        Container(
                          width: 150,
                          height: 15,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  equbType == EqubType.past || equbType == EqubType.active
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: LinearProgressIndicator(
                            value: 0.3,
                            minHeight: 10,
                            borderRadius: BorderRadius.circular(10),
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer
                                .withOpacity(0.3),
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer
                                    .withOpacity(0.7)),
                          ),
                        ),
                  equbType == EqubType.past
                      ? const SizedBox()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: equbType == EqubType.active
                                    ? [
                                        ...[1, 2, 3].map(
                                          (e) => Container(
                                            margin: const EdgeInsets.all(3),
                                            width: 25,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                        )
                                      ]
                                    : [
                                        ...[1, 2, 3, 4].map(
                                          (e) => Align(
                                            widthFactor: 0.8,
                                            child: Container(
                                              height: 40,
                                              width: 40,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: AppColors.onPrimary
                                                        .withOpacity(0.9)),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                              ),
                            ),
                            equbType == EqubType.pending
                                ? CustomOutlinedButton(
                                    child: "Invite others",
                                    onPressed: () {},
                                    showBackground: false)
                                : const SizedBox()
                          ],
                        ),
                ],
              ),
            ),
            equbType != EqubType.invites
                ? const SizedBox()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: CustomOutlinedButton(
                            onPressed: () {},
                            showBackground: true,
                            child: "Accept",
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: CustomOutlinedButton(
                            onPressed: () {},
                            showBackground: false,
                            child: "Decline",
                          ),
                        ),
                      ),
                    ],
                  ),
            equbType == EqubType.past
                ? const SizedBox()
                : Container(
                    width: double.infinity,
                    height: 60,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12))),
                  )
          ],
        ),
      ),
    );
  }
}

class PaymentStatusManagementPlaceholder extends StatelessWidget {
  const PaymentStatusManagementPlaceholder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SectionTitleTile(
          "Payment Status",
          Icons.payment_outlined,
          Text(''),
        ),
        Padding(
          padding: AppPadding.globalPadding.copyWith(
            top: 0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                period: const Duration(milliseconds: 2500),
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade200,
                child: Container(
                  width: 150,
                  height: 15,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                padding: AppPadding.globalPadding,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppBorder.radius,
                  boxShadow: AppShadows.cardShadows,
                ),
                child: Shimmer.fromColors(
                    period: const Duration(milliseconds: 2500),
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 125,
                                  height: 15,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  width: 75,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  width: 100,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  width: 50,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        CustomOutlinedButton(child: "", onPressed: () {}),
                        const SizedBox(height: 20),
                        LinearProgressIndicator(
                          value: 0.3,
                          minHeight: 10,
                          borderRadius: BorderRadius.circular(10),
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer
                              .withOpacity(0.3),
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer
                                  .withOpacity(0.7)),
                        ),
                        const SizedBox(height: 10),
                      ],
                    )),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class EqubStatusPlaceholder extends StatelessWidget {
  const EqubStatusPlaceholder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(milliseconds: 2500),
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 60,
            height: 15,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 75,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const Icon(
                Icons.circle,
                color: Colors.white,
                size: smallIconSize,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class EqubRoundPlaceholder extends StatelessWidget {
  const EqubRoundPlaceholder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return EqubDetailSummary(
      title: "Round",
      value: Shimmer.fromColors(
        period: const Duration(milliseconds: 2500),
        baseColor: AppColors.onSecondaryContainer.withOpacity(0.2),
        highlightColor: AppColors.onSecondaryContainer.withOpacity(0.3),
        child: Container(
          width: 50,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
      topRightVisual: Transform.scale(
        scale: 0.8,
        child: CircularProgressIndicator(
          value: 0.3,
          backgroundColor: AppColors.onSecondaryContainer.withOpacity(0.2),
          strokeWidth: 10,
          color: AppColors.onSecondaryContainer.withOpacity(0.6),
        ),
      ),
      additionalContentTitle: "Cycle",
      additionalContentValue: "",
    );
  }
}

class EqubAmountPlaceholder extends StatelessWidget {
  const EqubAmountPlaceholder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return EqubDetailSummary(
      title: "Contribution",
      value: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            period: const Duration(milliseconds: 2500),
            baseColor: AppColors.onSecondaryContainer.withOpacity(0.2),
            highlightColor: AppColors.onSecondaryContainer.withOpacity(0.3),
            child: Container(
              width: 50,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ],
      ),
      topRightVisual: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Row(
          children: [
            Icon(
              Icons.arrow_drop_down,
              size: 20,
              color: Theme.of(context).colorScheme.onTertiary,
            ),
          ],
        ),
      ),
      additionalContentTitle: "Amount",
      additionalContentValue: "",
    );
  }
}

class BiddingPlaceholder extends StatelessWidget {
  const BiddingPlaceholder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Shimmer.fromColors(
              period: const Duration(milliseconds: 2500),
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade200,
              child: Container(
                width: 300,
                height: 15,
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ],
        ),
        Container(
          decoration: PrimaryBoxDecor(),
          child: Shimmer.fromColors(
            period: const Duration(milliseconds: 2500),
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Theme.of(context)
                          .colorScheme
                          .onSecondaryContainer
                          .withOpacity(0.3),
                      size: 50.0,
                    ),
                    const Text(
                      '%',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_up_rounded,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      size: 50.0,
                    ),
                  ],
                ),
                const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: CustomOutlinedButton(child: "Place Bid"))
              ],
            ),
          ),
        )
      ],
    );
  }
}

class UserDetailPlaceholder extends StatelessWidget {
  const UserDetailPlaceholder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(milliseconds: 2500),
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade200,
      child: Container(
        width: 50,
        height: 50,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
      ),
    );
  }
}

class UsersListPlaceholder extends StatelessWidget {
  const UsersListPlaceholder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...[1, 2, 3].map(
          (e) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Shimmer.fromColors(
              period: const Duration(milliseconds: 2500),
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const UserDetailPlaceholder(),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 150,
                            height: 15,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: 100,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Container(
                    width: 70,
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class FriendshipsStatusButtonPlaceholder extends StatelessWidget {
  const FriendshipsStatusButtonPlaceholder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(milliseconds: 2500),
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade200,
      child: Container(
        width: 100,
        height: 35,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}

class UserJoineEqubsAndTrustedByPlaceholder extends StatelessWidget {
  const UserJoineEqubsAndTrustedByPlaceholder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        period: const Duration(milliseconds: 2500),
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Container(
                  width: 50,
                  height: 15,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 100,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            SizedBox(
              height: 50,
              child: VerticalDivider(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                thickness: 1,
              ),
            ),
            const SizedBox(width: 20),
            Column(
              children: [
                Container(
                  width: 50,
                  height: 15,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 100,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}

class UserDetailsSectionPlaceholder extends StatelessWidget {
  const UserDetailsSectionPlaceholder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Shimmer.fromColors(
        period: const Duration(milliseconds: 2500),
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade200,
        child: Column(
          children: [
            const SizedBox(height: 50),
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 150,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: 100,
              height: 15,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            const SizedBox(height: 10),
            const StarRating(
              rating: 4,
              color: Colors.white,
              starSize: 30,
            ),
            const SizedBox(height: 20),
            const FriendshipsStatusButtonPlaceholder(),
            const SizedBox(height: 40),
            const UserJoineEqubsAndTrustedByPlaceholder(),
            const SizedBox(height: 40),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PaymentMethodBox(
                  PaymentMethod(
                    id: 0,
                    service: "cash",
                    detail: "Cash",
                  ),
                ),
                PaymentMethodBox(
                  PaymentMethod(
                    id: 0,
                    service: "cash",
                    detail: "Cash",
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
