self: super:
{
  vscode-extensions = self.lib.recursiveUpdate super.vscode-extensions { };
}
