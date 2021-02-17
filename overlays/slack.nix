self: super: {
  slack = super.slack // {
    mac-app = {
      label = "Slack";
      icon = "slack.icns";
    };
  };
}
