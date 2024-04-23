import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timetrailblazer/config/constants_string.dart';
import 'package:timetrailblazer/config/constants_routes.dart';
import 'package:timetrailblazer/data/datasources/repositories/work_entry_repository.dart';
import 'package:timetrailblazer/data/models/work_entry_model.dart';
import 'package:timetrailblazer/domain/blocs/home_page/home_bloc.dart';
import 'package:timetrailblazer/presentation/widgets/app_bar.dart';
import 'package:timetrailblazer/presentation/widgets/auto_size_text.dart';
import 'package:timetrailblazer/presentation/widgets/spacer.dart';
import 'package:timetrailblazer/presentation/widgets/work_button.dart';

/// La schermata principale dell'applicazione.
class HomePageScreen extends StatelessWidget {
  /// Costruttore della classe `HomePageScreen`.
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: AppStrings.homeTitle,
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
          return FutureBuilder<WorkEntryModel?>(
            future: context.read<WorkEntryRepository>().getLastWorkEntry(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Mostra un indicatore di caricamento mentre si recupera l'ultima voce di lavoro
                return const Center(child: CircularProgressIndicator());
              }
              final lastWorkEntry = snapshot.data;
              final isEntryAllowed =
                  lastWorkEntry == null || !lastWorkEntry.isEntry!;
              final isExitAllowed =
                  lastWorkEntry != null && lastWorkEntry.isEntry!;
              return HomeScreen(
                isEntryAllowed: isEntryAllowed,
                isExitAllowed: isExitAllowed,
              );
            },
          );
        },
      ),
    );
  }
}

/// Il widget HomeScreen rappresenta il contenuto della schermata principale.
class HomeScreen extends StatelessWidget {
  /// Flag che indica se il pulsante di entrata è abilitato.
  final bool isEntryAllowed;

  /// Flag che indica se il pulsante di uscita è abilitato.
  final bool isExitAllowed;

  /// Costruttore della classe HomeScreen.
  ///
  /// Accetta i seguenti parametri:
  /// - isEntryAllowed: flag che indica se il pulsante di entrata è abilitato.
  /// - isExitAllowed: flag che indica se il pulsante di uscita è abilitato.
  const HomeScreen({
    super.key,
    required this.isEntryAllowed,
    required this.isExitAllowed,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Container(
              color: Colors.transparent,
            ),
          ),
          const CustomSpacer(flex: 1),
          Flexible(
            flex: 48,
            child: CustomAutoSizeText(
              AppStrings.appName,
              Theme.of(context).textTheme.headlineLarge!,
              TextAlign.center,
            ),
          ),
          Flexible(
            flex: 32,
            child: CustomAutoSizeText(
              AppStrings.appDescription,
              Theme.of(context).textTheme.bodyMedium!,
              TextAlign.center,
            ),
          ),
          const CustomSpacer(flex: 2),
          Flexible(
            flex: 16,
            child: WorkButton(
              label: AppStrings.entryButtonLabel,
              onPressed: isEntryAllowed
                  ? () => context.read<HomeBloc>().add(EntryButtonPressed())
                  : null,
            ),
          ),
          Flexible(
            flex: 16,
            child: WorkButton(
              label: AppStrings.exitButtonLabel,
              onPressed: isExitAllowed
                  ? () => context.read<HomeBloc>().add(ExitButtonPressed())
                  : null,
            ),
          ),
          Flexible(
            flex: 16,
            child: WorkButton(
              label: AppStrings.viewEntriesButtonLabel,
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.workEntries),
            ),
          ),
          const CustomSpacer(flex: 32),
          Flexible(
            flex: 8,
            child: CustomAutoSizeText(
              AppStrings.appFooter,
              Theme.of(context).textTheme.bodySmall!,
              TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
