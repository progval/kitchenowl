import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitchenowl/cubits/settings_cubit.dart';
import 'package:kitchenowl/enums/views_enum.dart';
import 'package:kitchenowl/kitchenowl.dart';

class ViewSettingsListTile extends StatelessWidget {
  final ViewsEnum view;
  final bool isActive;
  final bool showHandleIfNotOptional;

  const ViewSettingsListTile({
    super.key,
    required this.view,
    this.isActive = false,
    this.showHandleIfNotOptional = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        view.toLocalizedString(context),
      ),
      leading: Icon(view.toIcon()),
      contentPadding: const EdgeInsets.only(left: 20, right: 0),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (view.isOptional())
            KitchenOwlSwitch(
              value: isActive,
              onChanged: (value) =>
                  BlocProvider.of<SettingsCubit>(context).setView(view, value),
            ),
          if (view.isOptional())
            const VerticalDivider(
              endIndent: 4,
              indent: 4,
            ),
          if (showHandleIfNotOptional)
            const Padding(
              padding: EdgeInsets.only(left: 4, right: 16),
              child: Icon(Icons.drag_handle),
            ),
        ],
      ),
    );
  }
}
