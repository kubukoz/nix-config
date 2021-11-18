{ unstable }:
_: super:
{
  unstable = import unstable { inherit (super) system; };
}
