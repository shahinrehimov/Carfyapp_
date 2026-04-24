import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/router/app_router.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/confirmation_dialog.dart';
import 'package:carfy/common/widgets/custom_app_bar.dart';
import 'package:carfy/common/widgets/shimmer_wrapper.dart';
import 'package:carfy/common/widgets/state_status_toast.dart';
import 'package:carfy/domain/entities/auth/session.dart';
import 'package:carfy/presentation/sessions/state/sessions_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SessionsPage extends StatelessWidget implements AutoRouteWrapper {
  const SessionsPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      BlocProvider(create: (_) => SessionsCubit()..init(), child: this);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SessionsCubit>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWhite(title: context.localization.sessionsTitle),
      body: BlocListener<SessionsCubit, SessionsState>(
        listenWhen: (prev, curr) =>
            prev.status != curr.status || prev.logoutStatus != curr.logoutStatus,
        listener: (context, state) {
          showStateStatusToast(context, state.status);
          showStateStatusToast(context, state.logoutStatus);
          if (state.logoutStatus is StateStatusSuccess) {
            context.router.replaceAll([const LoginRoute()]);
          }
        },
        child: BlocBuilder<SessionsCubit, SessionsState>(
          builder: (context, state) {
            return state.status.maybeWhen(
              loading: () => const _SessionsShimmer(),
              orElse: () => _SessionsBody(state: state, cubit: cubit),
            );
          },
        ),
      ),
    );
  }
}

class _SessionsBody extends StatelessWidget {
  final SessionsState state;
  final SessionsCubit cubit;

  const _SessionsBody({required this.state, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        if (state.currentSession != null) ...[
          _SectionHeader(title: context.localization.sessionsCurrentSession),
          const SizedBox(height: 12),
          BlocBuilder<SessionsCubit, SessionsState>(
            buildWhen: (prev, curr) => prev.logoutStatus != curr.logoutStatus,
            builder: (context, s) => _SessionCard(
              session: state.currentSession!,
              isTerminating: s.logoutStatus is StateStatusLoading,
              onTerminate: () => showConfirmationDialog(
                context: context,
                title: context.localization.logoutConfirmTitle,
                description: context.localization.logoutConfirmDescription,
                confirmText: context.localization.sessionsTerminate,
                cancelText: context.localization.cancel,
                onConfirm: cubit.logoutCurrentSession,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
        _SectionHeader(title: context.localization.sessionsOtherSessions),
        const SizedBox(height: 12),
        if (state.otherSessions.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                context.localization.sessionsEmpty,
                style: const TextStyle(color: Color(0xFF717171), fontSize: 14),
              ),
            ),
          )
        else
          ...state.otherSessions.map((session) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: BlocBuilder<SessionsCubit, SessionsState>(
              buildWhen: (prev, curr) =>
                  prev.terminateStatus[session.id] != curr.terminateStatus[session.id],
              builder: (context, s) => _SessionCard(
                session: session,
                isTerminating: s.terminateStatus[session.id] is StateStatusLoading,
                onTerminate: () => showConfirmationDialog(
                  context: context,
                  title: context.localization.sessionsTerminateConfirmTitle,
                  description: context.localization.sessionsTerminateConfirmDescription,
                  confirmText: context.localization.sessionsTerminate,
                  cancelText: context.localization.cancel,
                  onConfirm: () => cubit.terminateSession(session.id),
                ),
              ),
            ),
          )),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  final Session session;
  final bool isTerminating;
  final VoidCallback? onTerminate;

  const _SessionCard({
    required this.session,
    required this.isTerminating,
    required this.onTerminate,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.colors;
    return Container(
      width: double.infinity,
      height: 90,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFEBEBEB)),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 19,
            top: 21,
            child: Text(
              session.deviceName,
              style: const TextStyle(
                color: Color(0xFF292929),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (session.location != null)
            Positioned(
              left: 19,
              top: 45,
              child: Text(
                session.location!,
                style: const TextStyle(color: Color(0xFF717171), fontSize: 12),
              ),
            ),
          Positioned(
            left: 19,
            top: session.location != null ? 61 : 45,
            child: Text(
              session.createdAt,
              style: const TextStyle(color: Color(0xFF717171), fontSize: 12),
            ),
          ),
          if (onTerminate != null)
            Positioned(
              right: 19,
              top: 31,
              child: isTerminating
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colors.secondary,
                      ),
                    )
                  : GestureDetector(
                      onTap: onTerminate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1, color: colors.secondary),
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        child: Text(
                          context.localization.sessionsTerminate,
                          style: TextStyle(
                            color: colors.secondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
            ),
        ],
      ),
    );
  }
}

class _SessionsShimmer extends StatelessWidget {
  const _SessionsShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => ShimmerWrapper(
        child: Container(
          height: 90,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
