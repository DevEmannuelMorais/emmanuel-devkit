# Emmanuel DevKit

CLI para preparar e gerenciar ambiente de desenvolvimento local com foco em projetos Java legado, Java moderno, Node.js, Maven, Tomcat e WildFly/JBoss.

O comando principal do projeto é:

```bash
edev
```

Além dele, o DevKit carrega atalhos no terminal, como:

```bash
java6
java8
java11
java17
java21

maven6
maven39

jbi
tci
ea
```

---

## Objetivo

O Emmanuel DevKit foi criado para padronizar tarefas comuns de ambiente local, como:

- instalar dependências básicas;
- gerenciar versões de Java pelo `mise`;
- gerenciar versões de Maven pelo `mise`;
- usar Java 6 em projetos legados;
- alternar entre Java 6, 8, 11, 17 e 21;
- alternar entre Maven legado e moderno;
- gerenciar Tomcat local;
- gerenciar WildFly/JBoss local;
- fazer deploy de projetos Maven;
- visualizar configuração global;
- disponibilizar atalhos úteis no terminal.

---

## Estrutura do projeto

```text
emmanuel-devkit/
├── bin/
│   └── edev
├── lib/
│   ├── core.sh
│   ├── prompts.sh
│   ├── paths.sh
│   ├── config.sh
│   ├── ubuntu.sh
│   ├── java.sh
│   ├── maven.sh
│   ├── node.sh
│   ├── project.sh
│   ├── servers.sh
│   ├── update.sh
│   └── migrations.sh
├── shell/
│   └── edev.zsh
├── installers/
│   ├── setup-base.sh
│   ├── setup-node.sh
│   ├── setup-java-legacy.sh
│   ├── setup-java-modern.sh
│   └── setup-servers.sh
├── install.sh
├── uninstall.sh
├── README.md
├── CHANGELOG.md
├── VERSION
└── .gitignore
```

---

## Instalação

Clone o projeto:

```bash
git clone https://github.com/SEU_USUARIO/emmanuel-devkit.git ~/dev/projects/tools/emmanuel-devkit
```

Entre na pasta:

```bash
cd ~/dev/projects/tools/emmanuel-devkit
```

Execute o instalador:

```bash
./install.sh
```

Recarregue o terminal:

```bash
source ~/.zshrc
```

Teste:

```bash
edev help
```

---

## O que o instalador faz

O `install.sh` configura o DevKit no arquivo de shell do usuário, normalmente:

```bash
~/.zshrc
```

Ele adiciona um bloco parecido com:

```bash
# >>> Emmanuel DevKit >>>
export EDEV_HOME="$HOME/dev/projects/tools/emmanuel-devkit"
export PATH="$EDEV_HOME/bin:$PATH"
[[ -f "$EDEV_HOME/shell/edev.zsh" ]] && source "$EDEV_HOME/shell/edev.zsh"
# <<< Emmanuel DevKit <<<
```

Esse bloco permite usar o comando:

```bash
edev
```

e também carrega os atalhos do terminal.

---

## Desinstalação

Para remover a integração do terminal:

```bash
cd ~/dev/projects/tools/emmanuel-devkit
./uninstall.sh
source ~/.zshrc
```

O desinstalador remove o bloco do DevKit do `.zshrc`, mas não apaga a pasta do projeto.

---

## Comandos principais

```bash
edev help
edev version
edev update
edev migrate
edev doctor
```

### `edev help`

Mostra a ajuda geral do CLI.

```bash
edev help
```

### `edev version`

Mostra a versão instalada.

```bash
edev version
```

### `edev update`

Atualiza o DevKit usando `git pull`.

```bash
edev update
```

### `edev migrate`

Executa ajustes automáticos de instalação.

```bash
edev migrate
```

### `edev doctor`

Verifica ferramentas importantes do ambiente.

```bash
edev doctor
```

---

## Configuração global

O DevKit possui um arquivo de configuração global em:

```bash
~/.config/edev/config
```

Esse arquivo funciona como um `.env` global do DevKit.

### Comandos

```bash
edev config list
edev config get <chave>
edev config set <chave> <valor>
edev config unset <chave>
edev config path
edev config keys
edev config edit
edev config reset
```

### Ver configurações

```bash
edev config list
```

Exemplo de saída:

```text
workspace.dir      = /home/usuario/dev
projects.dir       = /home/usuario/dev/projects
studies.dir        = /home/usuario/dev/studies
apps.dir           = /home/usuario/apps
jdks.dir           = /home/usuario/apps/jdks
java.default       = temurin-17
tomcat.version     = 9.0.118
wildfly.version    = 26.1.3.Final
tomcat.home        = /home/usuario/apps/tomcats/tomcat9
wildfly.home       = /home/usuario/apps/jbosses/wildfly26
shell.banner       = true
shell.tips         = true
```

### Ver uma chave específica

```bash
edev config get workspace.dir
edev config get java.default
```

### Alterar uma configuração

```bash
edev config set workspace.dir ~/dev
edev config set apps.dir ~/apps
edev config set java.default temurin-17
edev config set shell.banner true
```

### Ver caminho do arquivo

```bash
edev config path
```

### Ver chaves disponíveis

```bash
edev config keys
```

---

## Java

O DevKit gerencia Java usando `mise`.

Comandos oficiais:

```bash
edev java help
edev java info
edev java info 6
edev java list
edev java remote
edev java install <versao>
edev java use-global <versao>
edev java use-local <versao>
edev java use <versao>
edev java where
edev java which
edev java 6
edev java 8
edev java 11
edev java 17
edev java 21
```

### Ajuda Java

```bash
edev java help
```

### Ver Java atual

```bash
edev java info
```

Mostra:

- `java -version`;
- `javac -version`;
- `JAVA_HOME`;
- Maven ativo;
- Java configurado no `mise`.

### Listar Javas instalados

```bash
edev java list
```

### Listar versões disponíveis

```bash
edev java remote
```

### Instalar Java

```bash
edev java install temurin-8
edev java install temurin-11
edev java install temurin-17
edev java install temurin-21
```

### Usar Java global

```bash
edev java use-global temurin-17
```

Também existe o alias:

```bash
edev java use temurin-17
```

### Usar Java local no projeto

Dentro da pasta do projeto:

```bash
edev java use-local temurin-11
```

Isso configura o Java no projeto atual usando o `mise`.

### Atalhos Java

```bash
javaInfo
javaList
javaRemote
javaInstall temurin-11
javaUseGlobal temurin-17
javaUseLocal temurin-11
javaWhere
javaWhich

java6
java8
java11
java17
java21
```

---

## Java 6

O DevKit não baixa Java 6 automaticamente.

O Java 6 precisa ser obtido manualmente e registrado no `mise`.

Depois de registrado, ele funciona igual aos outros:

```bash
java6
```

ou:

```bash
edev java 6
```

### Estrutura esperada

Exemplo de JDK 6 baixado manualmente:

```bash
/home/usuario/apps/jdks/java6/jdk1.6.0_45
```

Essa pasta deve conter:

```text
jdk1.6.0_45/
├── bin/
│   ├── java
│   └── javac
└── jre/
```

Teste direto:

```bash
~/apps/jdks/java6/jdk1.6.0_45/bin/java -version
~/apps/jdks/java6/jdk1.6.0_45/bin/javac -version
```

Saída esperada:

```text
java version "1.6.0_45"
javac 1.6.0_45
```

### Registrar Java 6 no mise

```bash
mise link -f java@jdk6 "$HOME/apps/jdks/java6/jdk1.6.0_45"
```

Depois use:

```bash
mise use -g java@jdk6
```

Confirme:

```bash
java -version
javac -version
mise current java
mise where java
```

### Usar pelo DevKit

```bash
edev java 6
```

ou:

```bash
java6
```

---

## Maven

O DevKit gerencia Maven usando `mise`.

Comandos oficiais:

```bash
edev maven help
edev maven info
edev maven list
edev maven remote
edev maven install <versao>
edev maven use <versao>
edev maven 6
edev maven 39
```

### Ajuda Maven

```bash
edev maven help
```

### Ver Maven atual

```bash
edev maven info
```

### Listar Mavens instalados

```bash
edev maven list
```

### Listar versões disponíveis

```bash
edev maven remote
```

### Instalar Maven

```bash
edev maven install 3.2.5
edev maven install 3.9.16
```

### Usar Maven global

```bash
edev maven use 3.9.16
```

### Maven legado

Para Java 6, use Maven legado:

```bash
edev maven 6
```

Esse comando usa:

```bash
maven@3.2.5
```

Atalho:

```bash
maven6
```

### Maven moderno

Para Java moderno, use:

```bash
edev maven 39
```

Esse comando usa:

```bash
maven@3.9.16
```

Atalho:

```bash
maven39
```

### Atalhos Maven

```bash
mavenInfo
mavenList
mavenRemote
mavenInstall 3.2.5
mavenUse 3.9.16
maven6
maven39
```

---

## Combos recomendados

### Projeto legado Java 6

```bash
java6
maven6
java -version
mvn -version
```

O esperado é:

```text
Java version: 1.6.0_45
Apache Maven 3.2.5
```

### Projeto legado Java 8 ou 11

```bash
java8
maven6
mvn -version
```

ou:

```bash
java11
maven6
mvn -version
```

### Projeto moderno Java 17

```bash
java17
maven39
mvn -version
```

### Projeto moderno Java 21

```bash
java21
maven39
mvn -version
```

---

## Setup

O DevKit possui comandos para preparar ambiente.

```bash
edev setup base
edev setup node
edev setup java-legacy
edev setup java-modern
edev setup servers
edev setup all
```

### Setup base

```bash
edev setup base
```

Instala ferramentas básicas do sistema.

### Setup Node

```bash
edev setup node
```

Prepara ambiente Node.js.

### Setup Java legado

```bash
edev setup java-legacy
```

Fluxo voltado para projetos legados.

Pode instalar:

- `mise`;
- Java 8;
- Java 11;
- Maven;
- Ant.

Java 6 não é baixado automaticamente.

### Setup Java moderno

```bash
edev setup java-modern
```

Fluxo voltado para projetos modernos.

Pode instalar:

- `mise`;
- Java 17;
- Java 21;
- Maven;
- Gradle.

### Setup servidores

```bash
edev setup servers
```

Prepara estrutura para Tomcat e WildFly/JBoss.

### Setup completo

```bash
edev setup all
```

Executa todos os setups principais.

---

## Projeto atual

O DevKit consegue detectar projetos Maven pelo `pom.xml`.

Comandos:

```bash
edev project info
edev project root
```

### Ver informações do projeto

Dentro de um projeto Maven:

```bash
edev project info
```

Exemplo:

```text
Root:       /home/usuario/dev/projects/java/cliente-legado
Artifact:   cliente-legado
Final name: cliente-legado
Packaging:  war
Build file: /home/usuario/dev/projects/java/cliente-legado/target/cliente-legado.war
```

---

## Servidores

O DevKit possui comandos para Tomcat e WildFly/JBoss.

```bash
edev server tomcat ...
edev server jboss ...
```

---

## Tomcat

Comandos:

```bash
edev server tomcat info
edev server tomcat list
edev server tomcat start
edev server tomcat stop
edev server tomcat restart
edev server tomcat status
edev server tomcat log
edev server tomcat log80
edev server tomcat deploy
edev server tomcat clean-deploy
edev server tomcat kill
```

Atalhos:

```bash
tci
tcl
tcs
tcstop
tcr
tcst
tclog
tclog80
tcd
tcclean
tckill
```

Compatibilidade com CLI antigo:

```bash
tomcatStart
tomcatStop
tomcatRestart
tomcatLog
tomcatLog80
tomcatDeploy
tomcatKill
```

---

## WildFly / JBoss

Comandos:

```bash
edev server jboss info
edev server jboss list
edev server jboss start
edev server jboss start-bg
edev server jboss start-bg-8081
edev server jboss start-bg-8082
edev server jboss stop
edev server jboss restart
edev server jboss status
edev server jboss log
edev server jboss log80
edev server jboss deploy
edev server jboss deployments
edev server jboss clean-deploy
edev server jboss test-ds
edev server jboss kill
```

Atalhos:

```bash
jbi
jbl
jbs
jbbg
jbbg81
jbbg82
jbstop
jbr
jbst
jblog
jblog80
jbd
jbdep
jbclean
jbds
jbkill
```

Compatibilidade com CLI antigo:

```bash
jbossStart
jbossStop
jbossRestart
jbossLog
jbossLog80
jbossDeploy
jbossDeployments
jbossTestDs
jbossKill
```

---

## Deploy

O deploy usa o projeto Maven atual.

Dentro do projeto:

```bash
edev server jboss deploy
```

ou:

```bash
edev server tomcat deploy
```

O DevKit tenta detectar:

- diretório raiz do projeto;
- `artifactId`;
- `packaging`;
- `finalName`;
- arquivo `.war` gerado em `target`.

Também é possível passar o caminho do projeto:

```bash
edev server jboss deploy ~/dev/projects/java/cliente-legado
edev server tomcat deploy ~/dev/projects/java/cliente-legado
```

---

## Atalhos gerais

### Ajuda

```bash
ea
atalhos
```

Mostra os atalhos carregados no terminal.

### Geral

```bash
e       # edev
eh      # edev help
ev      # edev version
eu      # edev update
edoc    # edev doctor
```

### Pastas

```bash
dev
projects
studies
```

### Git

```bash
gs      # git status
ga      # git add
gc      # git commit -m
gp      # git push
gpl     # git pull
gl      # git log visual
gb      # git branch -a
```

### Docker

```bash
dc      # docker compose
dcu     # docker compose up -d
dcd     # docker compose down
dcl     # docker compose logs -f --tail=100
dps     # docker ps
```

---

## Banner do terminal

O DevKit pode mostrar um banner ao abrir o terminal.

Ativar:

```bash
edev config set shell.banner true
```

Desativar:

```bash
edev config set shell.banner false
```

O banner mostra informações reais do sistema, como:

- usuário;
- sistema operacional;
- ambiente;
- shell;
- Node;
- Java;
- Python;
- workspace;
- comandos de ajuda.

---

## Fluxo recomendado para novo usuário

Depois de instalar:

```bash
edev help
ea
edev config list
edev doctor
```

Preparar ambiente básico:

```bash
edev setup base
```

Para Java moderno:

```bash
edev setup java-modern
java17
maven39
```

Para Java legado:

```bash
edev setup java-legacy
java8
maven6
```

Para Java 6:

```bash
mise link -f java@jdk6 "$HOME/apps/jdks/java6/jdk1.6.0_45"
java6
maven6
```

---

## Troubleshooting

### `edev: command not found`

Recarregue o terminal:

```bash
source ~/.zshrc
```

Confira se o bloco do DevKit existe:

```bash
grep -n "Emmanuel DevKit" ~/.zshrc
```

Confira o caminho:

```bash
which edev
type -a edev
```

---

### `Comando inválido: config`

O `bin/edev` não está registrando o comando `config`.

Confira:

```bash
grep -nE "config\.sh|config\)" "$(which edev)"
```

A saída precisa mostrar:

```text
source "$EDEV_HOME/lib/config.sh"
config)
```

---

### `Comando inválido: maven`

O `bin/edev` não está registrando o comando `maven`.

Confira:

```bash
grep -nE "maven\.sh|maven\)" "$(which edev)"
```

A saída precisa mostrar:

```text
source "$EDEV_HOME/lib/maven.sh"
maven)
```

---

### `java6` ainda procura `~/apps/jdks/jdk6`

Isso significa que o terminal ainda está com função antiga carregada.

Limpe e recarregue:

```bash
unfunction java6 2>/dev/null || true
unalias java6 2>/dev/null || true

unset EDEV_SHELL_LOADED
unset EDEV_BANNER_SHOWN
source ~/.zshrc
```

Confirme:

```bash
type java6
```

O esperado é:

```text
java6 is an alias for edev java 6
```

ou uma função simples que chame:

```bash
edev java 6
```

---

### `mvn -version` mostra Java errado

Troque o combo completo.

Para legado Java 6:

```bash
java6
maven6
mvn -version
```

Para moderno Java 17:

```bash
java17
maven39
mvn -version
```

---

### Erro de completion Docker no Zsh

Erro comum:

```text
compinit: no such file or directory: /usr/share/zsh/vendor-completions/_docker
```

Limpe o cache do Zsh:

```bash
rm -f ~/.zcompdump*
```

Depois abra um novo terminal.

---

## Desenvolvimento

Antes de commitar, rode:

```bash
bash -n bin/edev
bash -n lib/*.sh
zsh -n shell/edev.zsh
```

Verifique os comandos principais:

```bash
edev help
edev config list
edev java help
edev maven help
edev doctor
```

Commits devem ser pequenos e objetivos.

Exemplos:

```bash
git add lib/maven.sh bin/edev shell/edev.zsh
git commit -m "feat: adicionar comandos maven pelo mise"
```

```bash
git add lib/java.sh shell/edev.zsh
git commit -m "refactor: usar java 6 pelo mise"
```

---

## Padrões do projeto

- Scripts pequenos e simples.
- Cada módulo cuida de uma responsabilidade.
- `java.sh` cuida de Java.
- `maven.sh` cuida de Maven.
- `servers.sh` cuida de Tomcat e WildFly/JBoss.
- `config.sh` cuida da configuração global.
- `shell/edev.zsh` cuida apenas de aliases, funções de terminal e banner.
- `bin/edev` apenas roteia comandos.
- Evitar duplicidade de regra entre shell e libs.
- Evitar comandos escondidos.
- Todo comando importante deve aparecer no `edev help` ou no help do módulo.

---

## Licença

Defina a licença do projeto conforme a necessidade do repositório.