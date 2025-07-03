allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

//subprojects {
//    beforeEvaluate { project ->
//        if (project.name == "ar_flutter_plugin") {
//            project.buildscript.dependencies.add("classpath", "org.jetbrains.kotlin:kotlin-gradle-plugin:1.8.20")
//        }
//    }
//}

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
