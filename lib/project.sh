# ============================================================
# Project - Emmanuel DevKit
# ============================================================

projectFindRoot() {
  local startDir="${1:-$(pwd)}"
  local currentDir

  currentDir="$(cd "$startDir" 2>/dev/null && pwd)"

  while [[ "$currentDir" != "/" ]]; do
    if [[ -f "$currentDir/pom.xml" ]]; then
      echo "$currentDir"
      return 0
    fi

    currentDir="$(dirname "$currentDir")"
  done

  return 1
}

projectReadPomValue() {
  local pomFile="$1"
  local tagName="$2"

  python3 - "$pomFile" "$tagName" <<'PY'
import sys
import xml.etree.ElementTree as ET

pom_file = sys.argv[1]
tag_name = sys.argv[2]

try:
    tree = ET.parse(pom_file)
    root = tree.getroot()
    namespace = ""

    if root.tag.startswith("{"):
        namespace = root.tag.split("}")[0] + "}"

    element = root.find(f"{namespace}{tag_name}")

    if element is not None and element.text:
        print(element.text.strip())
except Exception:
    sys.exit(1)
PY
}

projectGetArtifactId() {
  local projectDir="$1"
  local artifactId

  artifactId="$(projectReadPomValue "$projectDir/pom.xml" "artifactId" 2>/dev/null || true)"

  if [[ -z "$artifactId" ]]; then
    artifactId="$(basename "$projectDir")"
  fi

  echo "$artifactId"
}

projectGetPackaging() {
  local projectDir="$1"
  local packaging

  packaging="$(projectReadPomValue "$projectDir/pom.xml" "packaging" 2>/dev/null || true)"

  if [[ -z "$packaging" ]]; then
    packaging="jar"
  fi

  echo "$packaging"
}

projectGetFinalName() {
  local projectDir="$1"
  local finalName

  finalName="$(python3 - "$projectDir/pom.xml" <<'PY'
import sys
import xml.etree.ElementTree as ET

pom_file = sys.argv[1]

try:
    tree = ET.parse(pom_file)
    root = tree.getroot()
    namespace = ""

    if root.tag.startswith("{"):
        namespace = root.tag.split("}")[0] + "}"

    build = root.find(f"{namespace}build")

    if build is not None:
        final_name = build.find(f"{namespace}finalName")

        if final_name is not None and final_name.text:
            print(final_name.text.strip())
except Exception:
    sys.exit(0)
PY
)"

  echo "$finalName"
}

projectResolveArtifactName() {
  local projectDir="$1"
  local artifactId
  local finalName

  artifactId="$(projectGetArtifactId "$projectDir")"
  finalName="$(projectGetFinalName "$projectDir")"

  if [[ -n "$finalName" ]]; then
    echo "$finalName"
    return 0
  fi

  echo "$artifactId"
}

projectResolveArtifactFile() {
  local projectDir="$1"
  local packaging
  local artifactName
  local artifactFile

  packaging="$(projectGetPackaging "$projectDir")"
  artifactName="$(projectResolveArtifactName "$projectDir")"

  case "$packaging" in
    war)
      artifactFile="$projectDir/target/$artifactName.war"

      if [[ ! -f "$artifactFile" ]]; then
        artifactFile="$(find "$projectDir/target" -maxdepth 1 -type f -name "*.war" 2>/dev/null | head -n 1)"
      fi
      ;;

    jar)
      artifactFile="$projectDir/target/$artifactName.jar"

      if [[ ! -f "$artifactFile" ]]; then
        artifactFile="$(find "$projectDir/target" -maxdepth 1 -type f -name "*.jar" ! -name "*sources.jar" ! -name "*javadoc.jar" 2>/dev/null | head -n 1)"
      fi
      ;;

    *)
      artifactFile=""
      ;;
  esac

  echo "$artifactFile"
}

projectResolveCurrent() {
  local inputDir="${1:-$(pwd)}"
  local projectDir
  local artifactId
  local packaging
  local artifactName
  local artifactFile

  projectDir="$(projectFindRoot "$inputDir" || true)"

  if [[ -z "$projectDir" ]]; then
    fail "Projeto Maven nao encontrado. Entre em uma pasta com pom.xml ou informe o caminho."
    return 1
  fi

  artifactId="$(projectGetArtifactId "$projectDir")"
  packaging="$(projectGetPackaging "$projectDir")"
  artifactName="$(projectResolveArtifactName "$projectDir")"
  artifactFile="$(projectResolveArtifactFile "$projectDir")"

  export EDEV_PROJECT_ROOT="$projectDir"
  export EDEV_PROJECT_ARTIFACT_ID="$artifactId"
  export EDEV_PROJECT_PACKAGING="$packaging"
  export EDEV_PROJECT_ARTIFACT_NAME="$artifactName"
  export EDEV_PROJECT_ARTIFACT_FILE="$artifactFile"
}

projectInfo() {
  projectResolveCurrent "$1" || return 1

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "📦 Project Info"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Root:       $EDEV_PROJECT_ROOT"
  echo "Artifact:   $EDEV_PROJECT_ARTIFACT_ID"
  echo "Final name: $EDEV_PROJECT_ARTIFACT_NAME"
  echo "Packaging:  $EDEV_PROJECT_PACKAGING"

  if [[ -n "$EDEV_PROJECT_ARTIFACT_FILE" ]]; then
    echo "Build file: $EDEV_PROJECT_ARTIFACT_FILE"
  else
    echo "Build file: Ainda nao encontrado. Rode mvn clean package."
  fi

  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
}

projectCommand() {
  case "$1" in
    info|"")
      projectInfo "$2"
      ;;

    root)
      projectFindRoot "$2"
      ;;

    *)
      fail "Comando project invalido."
      echo "Use: edev project info"
      return 1
      ;;
  esac
}