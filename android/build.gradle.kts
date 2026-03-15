val customBuildDir = rootProject.layout.projectDirectory.dir("../build").asFile

rootProject.layout.buildDirectory.set(customBuildDir)

subprojects {
    val newSubprojectBuildDir = File(customBuildDir, project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)
}

subprojects {
    evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(customBuildDir)
}
