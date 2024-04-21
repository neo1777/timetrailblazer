import 'package:flutter/material.dart';
import 'package:timetrailblazer/presentation/widgets/auto_size_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final List<Widget>? onAction;

  const CustomAppBar({
    super.key,
    this.onBackPressed,
    this.onAction,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      //backgroundColor: Colors.transparent,
      automaticallyImplyLeading: true,
      actions: onAction,
      leading: IconButton(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        icon: const Icon(Icons.arrow_back_ios_new),
        onPressed: onBackPressed,
      ),
      title: CustomAutoSizeText(
        title,
        Theme.of(context).textTheme.titleSmall!,
        TextAlign.center,
      ),
      titleSpacing: 0,
      centerTitle: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(32);
}
