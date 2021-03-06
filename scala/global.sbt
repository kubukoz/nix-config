def supportedVersion(s: String) =
  s.startsWith("2.") || Set("3.0.0-M3", "3.0.0-RC1").contains(s)

libraryDependencies ++= {
  if(supportedVersion(scalaVersion.value))
    List("com.kubukoz" %% "debug-utils" % "1.1.0")
  else Nil
}
