def supportedVersion(s: String) =
  Set("2.12", "2.13", "3.0.0-RC2").exists(s.startsWith) || ("3.0.0" == s)

libraryDependencies ++= {
  if (supportedVersion(scalaVersion.value))
  //   List("com.kubukoz" %% "debug-utils" % "1.1.3")
  // else
    Nil
}
