def supportedVersion(s: String) =
  Set("2.12","2.13","3.0.0-RC2","3.0.0-RC3").exists(s.startsWith)

libraryDependencies ++= {
  if(supportedVersion(scalaVersion.value))
    List("com.kubukoz" %% "debug-utils" % "1.1.1")
  else Nil
}
