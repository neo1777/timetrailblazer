import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timetrailblazer/config/constants_routes.dart';
import 'package:timetrailblazer/config/constants_string.dart';
import 'package:timetrailblazer/domain/blocs/home_page/home_bloc.dart';
import 'package:timetrailblazer/domain/blocs/home_page/home_event.dart';
import 'package:timetrailblazer/domain/blocs/home_page/home_state.dart';
import 'package:timetrailblazer/presentation/widgets/auto_size_text.dart';
import 'package:timetrailblazer/presentation/widgets/common_body.dart';
import 'package:timetrailblazer/presentation/widgets/spacer.dart';
import 'package:timetrailblazer/presentation/widgets/work_button.dart';

/// La schermata principale dell'applicazione.
class HomePageScreen extends StatelessWidget {
  /// Costruttore della classe `HomePageScreen`.
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
        // Determina se il pulsante di entrata e di uscita devono essere abilitati o meno
        // in base allo stato corrente del BLoC

        bool isEntryAllowed = true;
        bool isExitAllowed = false;
        BlocProvider.of<HomeBloc>(context).add(HomeStarted());

        if (state is HomeEntryButtonEnabled) {
          isEntryAllowed = true;
          isExitAllowed = false;
        } else if (state is HomeExitButtonEnabled) {
          isExitAllowed = true;
          isEntryAllowed = false;
        }

        // Restituisce il widget `HomeScreen` con i flag appropriati per abilitare/disabilitare
        // i pulsanti di entrata e uscita
        return HomeScreen(
          isEntryAllowed: isEntryAllowed,
          isExitAllowed: isExitAllowed,
        );
      }),
    );
  }
}

/// Il widget HomeScreen rappresenta il contenuto della schermata principale.
///
/// Questo widget visualizza il titolo dell'app, una breve descrizione, e i pulsanti
/// per registrare un'entrata, un'uscita e visualizzare le voci di lavoro.
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
    return CommonBody(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CustomSpacer(flex: 5),
          Flexible(
            flex: 48,
            child: CustomAutoSizeText(
                AppStrings.appName,
                Theme.of(context).textTheme.headlineLarge!,
                TextAlign.center,
                null),
          ),
          Flexible(
            flex: 32,
            child: CustomAutoSizeText(
              AppStrings.appDescription,
              Theme.of(context).textTheme.bodyMedium!,
              TextAlign.center,
              null,
            ),
          ),
          const CustomSpacer(flex: 6),
          Flexible(
            flex: 16,
            child: WorkButton(
              label: AppStrings.entryButtonLabel,
              onPressed: isEntryAllowed
                  ? () {
                      context.read<HomeBloc>().add(EntryButtonPressed());
                    }
                  : null,
            ),
          ),
          Flexible(
            flex: 16,
            child: WorkButton(
              label: AppStrings.exitButtonLabel,
              onPressed: isExitAllowed
                  ? () {
                      context.read<HomeBloc>().add(ExitButtonPressed());
                    }
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
              null,
            ),
          ),
        ],
      ),
    );
  }
}
