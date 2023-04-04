# This file has been generated by node2nix 1.11.1. Do not edit!

{nodeEnv, fetchurl, fetchgit, nix-gitignore, stdenv, lib, globalBuildInputs ? []}:

let
  sources = {
    "arch-2.2.0" = {
      name = "arch";
      packageName = "arch";
      version = "2.2.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/arch/-/arch-2.2.0.tgz";
        sha512 = "Of/R0wqp83cgHozfIYLbBMnej79U/SVGOOyuB3VVFv1NRM/PSFMK12x9KVtiYzJqmnU5WR2qp0Z5rHb7sWGnFQ==";
      };
    };
    "clipboardy-3.0.0" = {
      name = "clipboardy";
      packageName = "clipboardy";
      version = "3.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/clipboardy/-/clipboardy-3.0.0.tgz";
        sha512 = "Su+uU5sr1jkUy1sGRpLKjKrvEOVXgSgiSInwa/qeID6aJ07yh+5NWc3h2QfjHjBnfX4LhtFcuAWKUsJ3r+fjbg==";
      };
    };
    "cross-spawn-7.0.3" = {
      name = "cross-spawn";
      packageName = "cross-spawn";
      version = "7.0.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.3.tgz";
        sha512 = "iRDPJKUPVEND7dHPO8rkbOnPpyDygcDFtWjpeWNCgy8WP2rXcxXL8TskReQl6OrB2G7+UJrags1q15Fudc7G6w==";
      };
    };
    "encoding-0.1.13" = {
      name = "encoding";
      packageName = "encoding";
      version = "0.1.13";
      src = fetchurl {
        url = "https://registry.npmjs.org/encoding/-/encoding-0.1.13.tgz";
        sha512 = "ETBauow1T35Y/WZMkio9jiM0Z5xjHHmJ4XmjZOq1l/dXz3lr2sRn87nJy20RupqSh1F2m3HHPSp8ShIPQJrJ3A==";
      };
    };
    "execa-5.1.1" = {
      name = "execa";
      packageName = "execa";
      version = "5.1.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/execa/-/execa-5.1.1.tgz";
        sha512 = "8uSpZZocAZRBAPIEINJj3Lo9HyGitllczc27Eh5YYojjMFMn8yHMDMaUHE2Jqfq05D/wucwI4JGURyXt1vchyg==";
      };
    };
    "get-stream-6.0.1" = {
      name = "get-stream";
      packageName = "get-stream";
      version = "6.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/get-stream/-/get-stream-6.0.1.tgz";
        sha512 = "ts6Wi+2j3jQjqi70w5AlN8DFnkSwC+MqmxEzdEALB2qXZYV3X/b1CTfgPLGJNMeAWxdPfU8FO1ms3NUfaHCPYg==";
      };
    };
    "human-signals-2.1.0" = {
      name = "human-signals";
      packageName = "human-signals";
      version = "2.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/human-signals/-/human-signals-2.1.0.tgz";
        sha512 = "B4FFZ6q/T2jhhksgkbEW3HBvWIfDW85snkQgawt07S7J5QXTk6BkNV+0yAeZrM5QpMAdYlocGoljn0sJ/WQkFw==";
      };
    };
    "iconv-lite-0.6.3" = {
      name = "iconv-lite";
      packageName = "iconv-lite";
      version = "0.6.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.6.3.tgz";
        sha512 = "4fCk79wshMdzMp2rH06qWrJE4iolqLhCUH+OiuIgU++RB0+94NlDL81atO7GX55uUKueo0txHNtvEyI6D7WdMw==";
      };
    };
    "is-docker-2.2.1" = {
      name = "is-docker";
      packageName = "is-docker";
      version = "2.2.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/is-docker/-/is-docker-2.2.1.tgz";
        sha512 = "F+i2BKsFrH66iaUFc0woD8sLy8getkwTwtOBjvs56Cx4CgJDeKQeqfz8wAYiSb8JOprWhHH5p77PbmYCvvUuXQ==";
      };
    };
    "is-stream-2.0.1" = {
      name = "is-stream";
      packageName = "is-stream";
      version = "2.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/is-stream/-/is-stream-2.0.1.tgz";
        sha512 = "hFoiJiTl63nn+kstHGBtewWSKnQLpyb155KHheA1l39uvtO9nWIop1p3udqPcUd/xbF1VLMO4n7OI6p7RbngDg==";
      };
    };
    "is-wsl-2.2.0" = {
      name = "is-wsl";
      packageName = "is-wsl";
      version = "2.2.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/is-wsl/-/is-wsl-2.2.0.tgz";
        sha512 = "fKzAra0rGJUUBwGBgNkHZuToZcn+TtXHpeCgmkMJMMYx1sQDYaCSyjJBSCa2nH1DGm7s3n1oBnohoVTBaN7Lww==";
      };
    };
    "isexe-2.0.0" = {
      name = "isexe";
      packageName = "isexe";
      version = "2.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/isexe/-/isexe-2.0.0.tgz";
        sha512 = "RHxMLp9lnKHGHRng9QFhRCMbYAcVpn69smSGcq3f36xjgVVWThj4qqLbTLlq7Ssj8B+fIQ1EuCEGI2lKsyQeIw==";
      };
    };
    "kleur-3.0.3" = {
      name = "kleur";
      packageName = "kleur";
      version = "3.0.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/kleur/-/kleur-3.0.3.tgz";
        sha512 = "eTIzlVOSUR+JxdDFepEYcBMtZ9Qqdef+rnzWdRZuMbOywu5tO2w2N7rqjoANZ5k9vywhL6Br1VRjUIgTQx4E8w==";
      };
    };
    "merge-stream-2.0.0" = {
      name = "merge-stream";
      packageName = "merge-stream";
      version = "2.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/merge-stream/-/merge-stream-2.0.0.tgz";
        sha512 = "abv/qOcuPfk3URPfDzmZU1LKmuw8kT+0nIHvKrKgFrwifol/doWcdA4ZqsWQ8ENrFKkd67Mfpo/LovbIUsbt3w==";
      };
    };
    "mimic-fn-2.1.0" = {
      name = "mimic-fn";
      packageName = "mimic-fn";
      version = "2.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/mimic-fn/-/mimic-fn-2.1.0.tgz";
        sha512 = "OqbOk5oEQeAZ8WXWydlu9HJjz9WVdEIvamMCcXmuqUYjTknH/sqsWvhQ3vgwKFRR1HpjvNBKQ37nbJgYzGqGcg==";
      };
    };
    "node-fetch-2.6.8" = {
      name = "node-fetch";
      packageName = "node-fetch";
      version = "2.6.8";
      src = fetchurl {
        url = "https://registry.npmjs.org/node-fetch/-/node-fetch-2.6.8.tgz";
        sha512 = "RZ6dBYuj8dRSfxpUSu+NsdF1dpPpluJxwOp+6IoDp/sH2QNDSvurYsAa+F1WxY2RjA1iP93xhcsUoYbF2XBqVg==";
      };
    };
    "npm-run-path-4.0.1" = {
      name = "npm-run-path";
      packageName = "npm-run-path";
      version = "4.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/npm-run-path/-/npm-run-path-4.0.1.tgz";
        sha512 = "S48WzZW777zhNIrn7gxOlISNAqi9ZC/uQFnRdbeIHhZhCA6UqpkOT8T1G7BvfdgP4Er8gF4sUbaS0i7QvIfCWw==";
      };
    };
    "onetime-5.1.2" = {
      name = "onetime";
      packageName = "onetime";
      version = "5.1.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/onetime/-/onetime-5.1.2.tgz";
        sha512 = "kbpaSSGJTWdAY5KPVeMOKXSrPtr8C8C7wodJbcsd51jRnmD+GZu8Y0VoU6Dm5Z4vWr0Ig/1NKuWRKf7j5aaYSg==";
      };
    };
    "path-key-3.1.1" = {
      name = "path-key";
      packageName = "path-key";
      version = "3.1.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/path-key/-/path-key-3.1.1.tgz";
        sha512 = "ojmeN0qd+y0jszEtoY48r0Peq5dwMEkIlCOu6Q5f41lfkswXuKtYrhgoTpLnyIcHm24Uhqx+5Tqm2InSwLhE6Q==";
      };
    };
    "prompts-2.4.2" = {
      name = "prompts";
      packageName = "prompts";
      version = "2.4.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/prompts/-/prompts-2.4.2.tgz";
        sha512 = "NxNv/kLguCA7p3jE8oL2aEBsrJWgAakBpgmgK6lpPWV+WuOmY6r2/zbAVnP+T8bQlA0nzHXSJSJW0Hq7ylaD2Q==";
      };
    };
    "safer-buffer-2.1.2" = {
      name = "safer-buffer";
      packageName = "safer-buffer";
      version = "2.1.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/safer-buffer/-/safer-buffer-2.1.2.tgz";
        sha512 = "YZo3K82SD7Riyi0E1EQPojLz7kpepnSQI9IyPbHHg1XXXevb5dJI7tpyN2ADxGcQbHG7vcyRHk0cbwqcQriUtg==";
      };
    };
    "shebang-command-2.0.0" = {
      name = "shebang-command";
      packageName = "shebang-command";
      version = "2.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/shebang-command/-/shebang-command-2.0.0.tgz";
        sha512 = "kHxr2zZpYtdmrN1qDjrrX/Z1rR1kG8Dx+gkpK1G4eXmvXswmcE1hTWBWYUzlraYw1/yZp6YuDY77YtvbN0dmDA==";
      };
    };
    "shebang-regex-3.0.0" = {
      name = "shebang-regex";
      packageName = "shebang-regex";
      version = "3.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/shebang-regex/-/shebang-regex-3.0.0.tgz";
        sha512 = "7++dFhtcx3353uBaq8DDR4NuxBetBzC7ZQOhmTQInHEd6bSrXdiEyzCvG07Z44UYdLShWUyXt5M/yhz8ekcb1A==";
      };
    };
    "signal-exit-3.0.7" = {
      name = "signal-exit";
      packageName = "signal-exit";
      version = "3.0.7";
      src = fetchurl {
        url = "https://registry.npmjs.org/signal-exit/-/signal-exit-3.0.7.tgz";
        sha512 = "wnD2ZE+l+SPC/uoS0vXeE9L1+0wuaMqKlfz9AMUo38JsyLSBWSFcHR1Rri62LZc12vLr1gb3jl7iwQhgwpAbGQ==";
      };
    };
    "sisteransi-1.0.5" = {
      name = "sisteransi";
      packageName = "sisteransi";
      version = "1.0.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/sisteransi/-/sisteransi-1.0.5.tgz";
        sha512 = "bLGGlR1QxBcynn2d5YmDX4MGjlZvy2MRBDRNHLJ8VI6l6+9FUiyTFNJ0IveOSP0bcXgVDPRcfGqA0pjaqUpfVg==";
      };
    };
    "strip-final-newline-2.0.0" = {
      name = "strip-final-newline";
      packageName = "strip-final-newline";
      version = "2.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/strip-final-newline/-/strip-final-newline-2.0.0.tgz";
        sha512 = "BrpvfNAE3dcvq7ll3xVumzjKjZQ5tI1sEUIKr3Uoks0XUl45St3FlatVqef9prk4jRDzhW6WZg+3bk93y6pLjA==";
      };
    };
    "tr46-0.0.3" = {
      name = "tr46";
      packageName = "tr46";
      version = "0.0.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/tr46/-/tr46-0.0.3.tgz";
        sha512 = "N3WMsuqV66lT30CrXNbEjx4GEwlow3v6rr4mCcv6prnfwhS01rkgyFdjPNBYd9br7LpXV1+Emh01fHnq2Gdgrw==";
      };
    };
    "webidl-conversions-3.0.1" = {
      name = "webidl-conversions";
      packageName = "webidl-conversions";
      version = "3.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-3.0.1.tgz";
        sha512 = "2JAn3z8AR6rjK8Sm8orRC0h/bcl/DqL7tRPdGZ4I1CjdF+EaMLmYxBHyXuKL849eucPFhvBoxMsflfOb8kxaeQ==";
      };
    };
    "whatwg-url-5.0.0" = {
      name = "whatwg-url";
      packageName = "whatwg-url";
      version = "5.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/whatwg-url/-/whatwg-url-5.0.0.tgz";
        sha512 = "saE57nupxk6v3HY35+jzBwYa0rKSy0XR8JSxZPwgLr7ys0IBzhGviA1/TUGJLmSVqs8pb9AnvICXEuOHLprYTw==";
      };
    };
    "which-2.0.2" = {
      name = "which";
      packageName = "which";
      version = "2.0.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/which/-/which-2.0.2.tgz";
        sha512 = "BLI3Tl1TW3Pvl70l3yq3Y64i+awpwXqsGBYWkkqMtnbXgrMD+yj7rhW0kuEDxzJaYXGjEW5ogapKNMEKNMjibA==";
      };
    };
  };
in
{
  dexsearch = nodeEnv.buildNodePackage {
    name = "dexsearch";
    packageName = "dexsearch";
    version = "0.1.5";
    src = fetchurl {
      url = "https://registry.npmjs.org/dexsearch/-/dexsearch-0.1.5.tgz";
      sha512 = "R4ZbsezgMVvRXUgbGS2PLvCoXwsBRK4jKgOpcK6y/oL8FvdviaPHIy2Jx0gp+HmXm6d4mX8kcJAc0vY9w3d/aQ==";
    };
    dependencies = [
      sources."arch-2.2.0"
      sources."clipboardy-3.0.0"
      sources."cross-spawn-7.0.3"
      sources."encoding-0.1.13"
      sources."execa-5.1.1"
      sources."get-stream-6.0.1"
      sources."human-signals-2.1.0"
      sources."iconv-lite-0.6.3"
      sources."is-docker-2.2.1"
      sources."is-stream-2.0.1"
      sources."is-wsl-2.2.0"
      sources."isexe-2.0.0"
      sources."kleur-3.0.3"
      sources."merge-stream-2.0.0"
      sources."mimic-fn-2.1.0"
      sources."node-fetch-2.6.8"
      sources."npm-run-path-4.0.1"
      sources."onetime-5.1.2"
      sources."path-key-3.1.1"
      sources."prompts-2.4.2"
      sources."safer-buffer-2.1.2"
      sources."shebang-command-2.0.0"
      sources."shebang-regex-3.0.0"
      sources."signal-exit-3.0.7"
      sources."sisteransi-1.0.5"
      sources."strip-final-newline-2.0.0"
      sources."tr46-0.0.3"
      sources."webidl-conversions-3.0.1"
      sources."whatwg-url-5.0.0"
      sources."which-2.0.2"
    ];
    buildInputs = globalBuildInputs;
    meta = {
      description = "CLI that uses the Scaladex API to quickly search libraries and copy them to the clipboard";
      homepage = "https://github.com/neandertech/scaladex-search#readme";
    };
    production = true;
    bypassCache = true;
    reconstructLock = true;
  };
}