allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Настройка путей сборки (build directory)
val rootBuildDir = rootProject.layout.buildDirectory.dir("../build")

subprojects {
    project.layout.buildDirectory.set(rootBuildDir.get().dir(project.name))
}

// Указание зависимости оценки проектов
subprojects {
    evaluationDependsOn(":app")
}

// Задача очистки
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}