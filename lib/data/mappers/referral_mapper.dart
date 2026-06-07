import 'package:carfy/domain/enums/attribution_status.dart';
import 'package:carfy/domain/enums/earning_status.dart';
import 'package:carfy/domain/enums/withdrawal_status.dart';
import 'package:carfy/data/models/referral/referral_balance_model.dart';
import 'package:carfy/data/models/referral/referral_earning_model.dart';
import 'package:carfy/data/models/referral/referral_info_model.dart';
import 'package:carfy/data/models/referral/referral_perks_model.dart';
import 'package:carfy/data/models/referral/referral_user_model.dart';
import 'package:carfy/data/models/referral/referral_withdrawal_model.dart';
import 'package:carfy/domain/entities/referral/referral_balance.dart';
import 'package:carfy/domain/entities/referral/referral_earning.dart';
import 'package:carfy/domain/entities/referral/referral_info.dart';
import 'package:carfy/domain/entities/referral/referral_perks.dart';
import 'package:carfy/domain/entities/referral/referral_user.dart';
import 'package:carfy/domain/entities/referral/referral_withdrawal.dart';
import 'package:injectable/injectable.dart';

@injectable
class ReferralMapper {
  ReferralBalance mapBalance(ReferralBalanceModel model) => ReferralBalance(
        pendingBalance: model.pendingBalance,
        availableBalance: model.availableBalance,
        lifetimeEarned: model.lifetimeEarned,
        lifetimeWithdrawn: model.lifetimeWithdrawn,
        lifetimeSpentOnPlatform: model.lifetimeSpentOnPlatform,
      );

  ReferralInfo mapInfo(ReferralInfoModel model) => ReferralInfo(
        code: model.code,
        link: model.link,
        tier: model.tier,
        rate: model.rate,
        isActive: model.isActive,
        totalReferrals: model.totalReferrals,
        activeReferrals: model.activeReferrals,
        pendingReferrals: model.pendingReferrals,
        pendingBalance: model.pendingBalance,
        availableBalance: model.availableBalance,
        lifetimeEarned: model.lifetimeEarned,
      );

  ReferralPerks mapPerks(ReferralPerksModel model) => ReferralPerks(
        hasPerks: model.hasPerks,
        freeDeliveryRemaining: model.freeDeliveryRemaining,
        discountOrdersRemaining: model.discountOrdersRemaining,
        discountRate: model.discountRate,
      );

  ReferralEarning mapEarning(ReferralEarningModel model) => ReferralEarning(
        id: model.id,
        amount: model.amount,
        orderAmount: model.orderAmount,
        rate: model.rate,
        tier: model.tier,
        status: EarningStatus.fromString(model.status),
        orderUuid: model.orderUuid,
        deliveredAt: model.deliveredAt,
        availableAt: model.availableAt,
        creditedAt: model.creditedAt,
      );

  ReferralUser mapReferralUser(ReferralUserModel model) => ReferralUser(
        referredName: model.referredName,
        status: AttributionStatus.fromString(model.status),
        activatedAt: model.activatedAt,
        joinedAt: model.joinedAt,
      );

  ReferralWithdrawal mapWithdrawal(ReferralWithdrawalModel model) => ReferralWithdrawal(
        id: model.id,
        amount: model.amount,
        fee: model.fee,
        netAmount: model.netAmount,
        cardLast4: model.cardLast4,
        cardHolderName: model.cardHolderName,
        status: WithdrawalStatus.fromString(model.status),
        adminNote: model.adminNote,
        requestedAt: model.requestedAt,
        processedAt: model.processedAt,
      );
}
