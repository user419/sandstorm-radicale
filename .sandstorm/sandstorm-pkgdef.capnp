@0x86488d48cd81761e;

using Spk = import "/sandstorm/package.capnp";
# This imports:
#   $SANDSTORM_HOME/latest/usr/include/sandstorm/package.capnp
# Check out that file to see the full, documented package definition format.

const pkgdef :Spk.PackageDefinition = (
  # The package definition. Note that the spk tool looks specifically for the
  # "pkgdef" constant.

  id = "8kr4rvyrggvzfvc160htzdt4u5rfvjc2dgdn27n5pt66mxa40m1h",
  # Your app ID is actually its public key. The private key was placed in
  # your keyring. All updates must be signed with the same key.

  manifest = (
    # This manifest is included in your app package to tell Sandstorm
    # about your app.

    appTitle = (defaultText = "Radicale"),

    appVersion = 15,  # Increment this for every release.

    appMarketingVersion = (defaultText = "2.1.10+v15"),
    # Human-readable representation of appVersion. Should match the way you
    # identify versions of your app in documentation and marketing.

    actions = [
      ( title = (defaultText = "New Calendar"),
        nounPhrase = (defaultText = "calendar"),
        command = .caldavCommand,
      ),
      ( title = (defaultText = "New Addressbook"),
        nounPhrase = (defaultText = "addressbook"),
        command = .carddavCommand,
      ),
    ],

    continueCommand = .continueCommand,
    # This is the command called to start your app back up after it has been
    # shut down for inactivity. Here we're using the same command as for
    # starting a new instance, but you could use different commands for each
    # case.

    metadata = (
      icons = (
        # Various icons to represent the app in various contexts.
        appGrid = (svg = embed "logo.svg"),
        grain = (svg = embed "logo.svg"),
        market = (svg = embed "logo.svg"),
        marketBig = (svg = embed "logo.svg"),
      ),

      website = "http://radicale.org",
      codeUrl = "https://github.com/synchrone/sandstorm-radicale",
      license = (openSource = gpl3),
      categories = [productivity],

      author = (
        contactEmail = "syn+sandstorm-radicale@syn.im",

        pgpSignature = embed "pgp-signature",
        # PGP signature attesting responsibility for the app ID. This is a binary-format detached
        # signature of the following ASCII message (not including the quotes, no newlines, and
        # replacing <app-id> with the standard base-32 text format of the app's ID):
        #
        # "I am the author of the Sandstorm.io app with the following ID: <app-id>"
        #
        # You can create a signature file using `gpg` like so:
        #
        #     echo -n "I am the author of the Sandstorm.io app with the following ID: <app-id>" | gpg --sign > pgp-signature
        #
        # Further details including how to set up GPG and how to use keybase.io can be found
        # at https://docs.sandstorm.io/en/latest/developing/publishing-apps/#verify-your-identity

        upstreamAuthor = "Kozea",
      ),

      pgpKeyring = embed "pgp-keyring",
      # A keyring in GPG keyring format containing all public keys needed to verify PGP signatures in
      # this manifest (as of this writing, there is only one: `author.pgpSignature`).
      #
      # To generate a keyring containing just your public key, do:
      #
      #     gpg --export <key-id> > keyring
      #
      # Where `<key-id>` is a PGP key ID or email address associated with the key.

      description = (defaultText = embed "description.md"),
      shortDescription = (defaultText = "Calendars and Contacts"),
      screenshots = [
        (width = 1265, height = 785, jpeg = embed "screenshots/1.png"),
        (width = 1265, height = 785, jpeg = embed "screenshots/2.png"),
        (width = 1265, height = 785, jpeg = embed "screenshots/3.png"),
        (width = 1265, height = 785, jpeg = embed "screenshots/4.png"),
        (width = 1265, height = 785, jpeg = embed "screenshots/5.png"),
        (width = 1265, height = 785, jpeg = embed "screenshots/6.png"),
        (width = 1265, height = 785, jpeg = embed "screenshots/7.png"),
      ],
      changeLog = (defaultText = embed "changelog.md"),
    ),
  ),

  sourceMap = (
    # Here we defined where to look for files to copy into your package. The
    # `spk dev` command actually figures out what files your app needs
    # automatically by running it on a FUSE filesystem. So, the mappings
    # here are only to tell it where to find files that the app wants.
    searchPath = [
      ( sourcePath = "." ),  # Search this directory first.
      ( sourcePath = "/",    # Then search the system root directory.
        hidePaths = [ "home", "proc", "sys",
                      "etc/passwd", "etc/hosts", "etc/host.conf",
                      "etc/nsswitch.conf", "etc/resolv.conf" ]
        # You probably don't want the app pulling files from these places,
        # so we hide them. Note that /dev, /var, and /tmp are implicitly
        # hidden because Sandstorm itself provides them.
      )
    ]
  ),

  fileList = "sandstorm-files.list",
  # `spk dev` will write a list of all the files your app uses to this file.
  # You should review it later, before shipping your app.

  alwaysInclude = [
    "opt/app/env",
    "opt/app/importapp",
    "opt/app/webassets_config",
    "opt/app/infcloud",
    "usr/lib/python3.4", # pull in the whole Python 3 runtime
    "usr/lib/python3", # pull in any Debian pure-Python packages
  ],
  # Fill this list with more names of files or directories that should be
  # included in your package, even if not listed in sandstorm-files.list.
  # Use this to force-include stuff that you know you need but which may
  # not have been detected as a dependency during `spk dev`. If you list
  # a directory here, its entire contents will be included recursively.

  bridgeConfig = (
    viewInfo = (
      permissions = [
        (
          name = "readonly",
          title = (defaultText = "readonly"),
          description = (defaultText = "Read-only access"),
        ),
        (
          name = "owner",
          title = (defaultText = "owner"),
          description = (defaultText = "Full access"),
        ),
      ],
      roles = [
        (
          title = (defaultText = "viewer"),
          permissions  = [true, false],
          verbPhrase = (defaultText = "can view"),
          description = (defaultText = "viewers may view what other users have stored"),
        ),
        (
          title = (defaultText = "owner"),
          permissions  = [false, true],
          verbPhrase = (defaultText = "has full access"),
          description = (defaultText = "has full access"),
        ),
      ],
    )
  ),
);

const caldavCommand :Spk.Manifest.Command = (
  argv = ["/sandstorm-http-bridge", "8000", "--", "/opt/app/.sandstorm/new-instance.sh"],
  environ = [
    (key = "PATH", value = "/usr/local/bin:/usr/bin:/bin"),
    (key = "SUBAPP", value = "caldav"),
  ]
);
const carddavCommand :Spk.Manifest.Command = (
  argv = ["/sandstorm-http-bridge", "8000", "--", "/opt/app/.sandstorm/new-instance.sh"],
  environ = [
    (key = "PATH", value = "/usr/local/bin:/usr/bin:/bin"),
    (key = "SUBAPP", value = "carddav"),
  ]
);
const continueCommand :Spk.Manifest.Command = (
  argv = ["/sandstorm-http-bridge", "8000", "--", "/opt/app/.sandstorm/launcher.sh"],
  environ = [(key = "PATH", value = "/usr/local/bin:/usr/bin:/bin")]
);
