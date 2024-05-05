sealed class GroupSettingsState {
  const GroupSettingsState();

  factory GroupSettingsState.ready() = GroupSettingsReadyState;
}

class GroupSettingsReadyState extends GroupSettingsState {}
