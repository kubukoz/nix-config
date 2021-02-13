libraryDependencies ++= {
  if(scalaVersion.value.startsWith("2")) List("com.kubukoz" %% "debug-utils" % "1.0.0")
  else Nil
}
